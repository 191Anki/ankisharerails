class ProfileController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  
  def index
    @user = User.find(current_user)
    @udecks = Deck.where( :user_name => @user.email)
    #@udecks = Deck.where
    @filterrific = Filterrific.new(Deck,
      params[ :filterrific] || session[ :filterrific_decks]
    )
    @decks = Deck.filterrific_find(@filterrific).page(params[ :page])
    session[ :filterrific_decks] = @filterrific.to_hash
  end

  def show
    @users = User.all
    @decks = Deck.all
  end
end
