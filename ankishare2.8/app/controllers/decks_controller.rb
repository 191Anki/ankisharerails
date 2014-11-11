class DecksController < ApplicationController
before_filter :authenticate_user!  
  helper_method :sort_column, :sort_direction

  def index
    @sort = Deck.order(sort_column + ' ' + sort_direction)
    @filterrific = Filterrific.new(
      Deck,
      params[ :filterrific] || session[ :filterrific_decks]
    )
    @decks = Deck.filterrific_find(@filterrific).page(params[ :page])
    session[ :filterrific_decks] = @filterrific.to_hash

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show

  end

  def reset_filterrific
    session[ :filterrific_decks] = nil
    redirect_to :action => :index
  end  

  def sort_column
    Deck.column_names.include?(params[ :sort]) ? params[ :sort] : "name"
  end

  def new 
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(upload_params)
    if @deck.save
      redirect_to :action => "load_from_apkg", notice: "#{@deck.attachment} has been uploaded."
    else
      render "new"
    end
  end
 
  def load_from_apkg
    @deck = Deck.new
    @deck.save
 
   # `cd root/ankishare2.8/uploads/deck/attachment/42`
   # `unzip #{apkg_file}`
   # `unzip '*'`
    
    require 'rubygems'
    require 'zip'   
    require 'json'

    folder = "/root/ankishare2.8/ankiFiles/"
    collection_file = "collection.anki2"
    zipfile_name = "/root/ankishare2.8/public/uploads/deck/attachment/42/*.apkg"

    Zip::File.open(zipfile_name) do |zipfile|
      
      images = JSON.parse(File.read("media"))
      
      for key, value in images
        `mv #{key} "#{value}"`
      end

      `sqlite3 -csv collection.anki2 "SELECT flds, sfld FROM notes" > deck.csv`

    end

    require 'csv'
    deck_data = CSV.read('deck.csv')

    for row in deck_data
      card = Card.new
      card.card_front = row[1]
      card.card_back = row[0]
      card.save
    end
  end

  def destroy
    @deck = Deck.find(params[ :id])
    @deck.destroy
    redirect_to decks_path, notice: "#{@deck.attachment} has been deleted."
  end

  private
    def upload_params
      params.require( :deck).permit( :author, :topic_id, :attachment, :class_name_id, :year_id, :professor_id)
    end

  def extension_white_list
    %w(apkg)
  end

  private
  def sort_column
    Deck.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
   
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

end


