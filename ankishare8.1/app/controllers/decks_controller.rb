# Load zip and json ruby modules
require 'rubygems'
require 'zip'
require 'json'
# Load sqlite3 module for querying the SQLITE3 database
require 'sqlite3'

class DecksController < ApplicationController
  before_filter :authenticate_user!  
  helper_method :sort_column, :sort_direction

# list all decks from the database
  def index
    @user = User.find(current_user)
    @sort = Deck.order(sort_column + ' ' + sort_direction)
    @filterrific = Filterrific.new(
      @sort,
      params[ :filterrific] || session[ :filterrific_decks]
    )
    @decks = @sort.where(:year_id => @user.student_year).filterrific_find(@filterrific).page(params[ :page])
    session[ :filterrific_decks] = @filterrific.to_hash

    respond_to do |format|
      format.html
      format.js
    end
  end

# Reset filters
  def reset_filterrific
    session[ :filterrific_decks] = nil
    redirect_to :action => :index
  end  

# Initialize new decks
  def new 
    @deck = Deck.new
    @user = User.find(current_user)
  end

# Create a new deck
  def create
    @deck = Deck.new(upload_params)
    @user = User.find(current_user)
    @deck.user_name = @user.email
    #@deck.deck_id = @deck.increment( :deck_id, by = 1)
    if @deck.save
      # Save the decks attachmenti name in the session for processing
      # by load_from_apkg
      #
      @deck.reload
      @deck.deck_id = @deck.id
      session[:attachment] = @deck.attachment.to_s    
      session[:deck_id] = @deck.deck_id
      redirect_to :action => "load_from_apkg", 
    notice: "#{@deck.attachment} has been uploaded."
      @deck.save
    else
      render "new"
    end
  end

# Process and upload contents of the uploaded deck into the database

  def load_from_apkg
 
   # decks are uploaded into RAILS.ROOT/public/uploads/deck/attachment
   # instead of hardcoding this, we will dynamically assemble the file
   # path from #{attachment} and RAILS.root variables.
   # f_path is the location where we will unzip and process the
   # the apkg files.
    
    file_dir = Rails.root.join("public")
    attach_file = session[:attachment]
    deck_id = session[:deck_id]
    file_path = File.join(file_dir,attach_file)

    # Extract the apkg into a temporary directory and remove once
    # all files are processed. We do this to address the use case where two 
    # users trying to upload decks at the same time (since there are common 
    # files like media, and 
    # collections.anki2, which will get overwritten and create conflicts.
    # Creating Staging directory and create temp directory underneath for
    # each upload 
    staging_dir = Rails.root.join("Staging") 
    temp_name = deck_id.to_s; 
    
    media_dir = File.join(staging_dir, temp_name)
    media_file = File.join(media_dir, "media")
    # Process Zip files package
    Zip::File.open(file_path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(media_dir, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
      
      # Refer to this links for using linux commands on ruby on rails
      # http://richonrails.com/articles/basic-file-and-directory-operations-in-ruby
      images = JSON.parse(File.read(media_file))      
      # Open the media file, and rename all media files with their JPG
      # filenames. 
      #
      Dir.chdir(media_dir)
      images.each do |key, value|
        # Copy them to rail application image directory
        File.rename(key, value)
      end
 
    end    

    # Possibly try this: http://zetcode.com/db/sqliteruby/queries/
    # TODO: replace with SQLITE module calls
    `sqlite3 -csv collection.anki2 "SELECT id, flds, sfld FROM notes" > deck.csv`
    #@cards = Card.find(params[:id])
 
    require 'csv'
    deck_data = CSV.foreach('deck.csv', "r:bom|utf-8") do |column|
      card = Card.new
      card.card_id = column[0] 
      card.card_front = column[2]
      card.card_back = column[1]
      card.deck_id = deck_id
      puts card.inspect
      card.save
    end
    # clean up the deck.csv from the media directory
    if File.exist?("deck.csv")
      File.delete("deck.csv")
    end
    # go back to decks_path
    @user = User.find(current_user)
    @user.increment!(:ucounter)
    redirect_to decks_path, notice: "#{attach_file} has been uploaded."

  end

  # Finds cards that associated with deck
  # Redirects to cards controller for editing and viewing methods
  def edit
    @card = Deck.find(params[ :deck_id][ :id])
    redirect_to cards_path, notice: "Finished."
  end

  # Updated the logic to clean up database and directory on
  # deleting the decks from the system.
  def destroy
    # select the deck and its children to be deleted
    @deck = Deck.find(params[ :id])
    @cards = Card.where(:deck_id => :id)

    # Let us cleanup the upload and Staging directories for this deck to
    # avoid cluttering directories with orphan files & directories.
    staging_dir = Rails.root.join("Staging")
    staging_dir = File.join(staging_dir, @deck.id.to_s) 
    puts "Deleting #{staging_dir} ..."

    # Remove staging director for :id recursively
    upload_root = Rails.root.join("public")
    upload_filedir = "/uploads/deck/attachment/" + @deck.id.to_s
    upload_dir = File.join(upload_root, upload_filedir)
    puts "Deleting #{upload_dir} ..."
    FileUtils.rm_rf(upload_dir)

    #Remove Cards and Deck records from the database.
    # we will first remove all children of the deck in the cards database
    # then we remove the deck.
    @cards.delete_all
    @deck.destroy
    redirect_to decks_path, notice: "#{@deck.attachment} has been deleted."
  end

  # Repackaging the Deck for download
  # Last edit: Dillon Gee, Feb 2nd, 2015
  # 1. Create a temporary directory for packaging the files
  # 2. Staging is a working directory for the Ankishare system and we don't want to
  #    manipulate any files in this directory. We will do our prep work in a temporary
  #    directory, create the zip files, copy to public folder for download, then 
  #    delete the temporary directory. 
  #
  def repackage
    require 'rubygems'
    require 'zip'
    require 'tmpdir'
    require 'csv'
    # Reload the deck from the database using the deck_id passed
    # from decks list view
    file_dir_root = Rails.root.join("public")
    @deck = Deck.find(params[:id])
    @user = User.find(current_user)
    download_filedir = "/uploads/deck/attachment/" + @deck.id.to_s
    file_path = File.join(file_dir_root,download_filedir)
    puts "File Dir = " + file_path
    pkg_filename = File.basename(@deck.attachment.to_s) 
    zipfile_name = ""
    # Now create a tmp directory for generating the updated
    # deck and prepare the new .apkg file 
    # we need to rename all media files back to numbers as
    # mapped in the media file

    Dir.mktmpdir do |dir|
      puts "My new temp dir: #{dir}"
      # Copy deck directory from $ROOT/Staging/:deck_id to tempdir
      deck_path = "Staging/" + @deck.id.to_s
      deck_src_dir = Rails.root.join(deck_path)
      FileUtils.cp_r(deck_src_dir,dir)
      media_dir = File.join(dir, @deck.id.to_s)
      puts "Media Directory = " + media_dir
      folder = "";

      # Add to media file new extensions for added photos
      # i.e 25, paste-12345.jpg
      # Rename images to numbers using JSON
      media_file = File.join(media_dir, "media")

      images = JSON.parse(File.read(media_file))   
      Dir.chdir(media_dir)
      images.each do |value, key|
        # Copy them to rail application image directory
        File.rename(key, value)
      end
      zipfile_name = File.join(file_path, pkg_filename)
      # Make sure that there are no stray zip file already exists
      #
      if File.exist?(zipfile_name)
        puts "File #{zipfile_name} exists. Deleting file .."
        File.delete(zipfile_name)
      end
      ## Need to update the NOTES table collection.anki2
      ## TO DO: Update collections.anki2 from the database
      config   = Rails.configuration.database_configuration
      database = config[Rails.env]["database"]
      db_path = Rails.root.join(database);
      puts "Connecting to #{db_path} ..."
      `sqlite3 -csv #{db_path} "SELECT card_id, card_front, card_back FROM cards" > notes.csv`
      #
      notes_data = CSV.foreach('notes.csv') do |column|
        card_id = column[0]
        sfld = column[1]
        flds = column[2]
        # if there are any single quotes in the data, we need to escape them to
        # to make sure that SQLITE updates will not fail.
        sfld = sfld.gsub("'", "''").gsub('"', '\\"')
        flds = flds.gsub("'", "''").gsub('"', '\\"')
        #puts "Updating #{card_id} ..."
        upd_string = "UPDATE notes SET sfld ='" + sfld.to_s + "', flds = '" +
          flds.to_s + "' where id = " + card_id.to_s
        # Import csv file into collection.anki2
        # Replaces the sflds and flds
        `sqlite3 collection.anki2 "#{upd_string}" `
      end
       # We have successflly updated the database. Now clean up notes.csv
       # from the temp directory.
      if File.exist?("notes.csv")
        File.delete("notes.csv")
      end

      ## Need to update the NOTES table collection.anki2
       puts "Creating Zip File " + zipfile_name 
       Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
         input_filenames = Dir.glob("**")
         puts input_filenames.inspect
         input_filenames.each do |filename|
           zipfile.add(filename, filename) 
         end
       end
       # Change permissions so user can access deck and download from server
       File.chmod(0777,zipfile_name) 
    end
    # end of tempdir blocl. it deletes the tmpdir at this point
    puts "Deck #{@deck.id} successfully packaged to #{pkg_filename}" 
    @deck.increment!(:counter)
    @user.increment!(:dcounter)    
    #send_file zipfile_name, :filename => pkg_filename, :type=>"application/zip" 
    redirect_to @deck.attachment.url
  end

  private
    # Database values needed when uploading a deck
    def upload_params
      params.require( :deck).permit( :author, :topic_id, :attachment, :class_name_id, :year_id, :professor_id, :deck_id)
    end
  
  # Restricts upload to only .apkg decks
  def extension_white_list
    %w(apkg)
  end

  # For column sorting of decks
  private
  def sort_column
     puts params[:filterrific_decks]
    Deck.column_names.include?(params[:sort_column]) ? params[:sort_column] : "topic_id"
  end
   
  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ?  params[:sort_direction] : "asc"
  end

end


