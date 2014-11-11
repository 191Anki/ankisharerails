class DecksController < ApplicationController
before_filter :authenticate_user!  
#  helper_method :sort_column, :sort_direction

  def index
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
      redirect_to decks_path, notice: "#{@deck.attachment} has been uploaded."
      # redirect_to :action => "load_from_apkg", notice: "#{@deck.attachment} has been uploaded."
    else
      render "new"
    end
  end
 
  def load_from_apkg
  
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

end


