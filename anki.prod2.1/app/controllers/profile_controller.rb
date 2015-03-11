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

  # Shows all decks and all users in Informatics Report  
  def show
    @users = User.all
    @decks = Deck.all
  end

end
