class ProfileController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  
  # Shows decks specified of current user
  # Uses filterrific filtering
  def index
    @user = User.find(current_user)
    @udecks = Deck.where( :user_name => @user.email)
    @filterrific = Filterrific.new(Deck,
      params[ :filterrific] || session[ :filterrific_decks]
    )
    @decks = Deck.filterrific_find(@filterrific).page(params[ :page])
    session[ :filterrific_decks] = @filterrific.to_hash
  end

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

  # Shows all decks and all users in Informatics Report  
  def show
    @users = User.all
    @decks = Deck.all
  end

end
