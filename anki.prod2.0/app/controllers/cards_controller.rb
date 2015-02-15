class CardsController < ApplicationController
  def new
    @card = Card.new
  end

  def index
    @cards = Card.all
   
  end

  def edit
    @card = Card.find(params[:id])
  end

  # modified by Vamsi Koduru, Dec 10, 2014
  def show
    # let us rember the deck_id of the cards shown
    # we need deck_id to dynamically serve the image files to the
    # browser. We save the deck_id passed as :id param into the session
    # and that variable will be used by sendimg when the sendimg is called
    # to serve a specific image of the cards that belong to the deck_id
    session[:deck_id] = params[:id]
    # list all cards for the given deck
    @cards = Card.where(deck_id: params[:id])
  end

  # Added by Vamsi Koduru, Dec 10, 2014
  # when the raw files are served by ActionView renderer all image files are
  # served through GET /cards/:filename where :filename is the name of the image file
  # we mapped the routes through
  # match 'cards/:filename' =>  'cards#sendimg', via: :get
  # in config/routes.rb
  # added following method to the image serving. We will use send_file 
  # to send the image file directly to the browser.
  def sendimg
    # which deck? get the deck_id we stored in the session
    deck_id = session[:deck_id]
    # construct the image file path name by prefix Rails.root to
    # Staging/{deck_id}/img_filename.jpg 
    directory_name = "Staging/" + deck_id.to_s
    img_filename = params[:filename]+".jpg"
    # now we have the fully qualified filename for the image file.
    # send this file to the browser using the send_file command.
    send_file Rails.root.join(directory_name, img_filename), 
				type: "image/jpg", disposition: "inline"
  end
  #
  def img_path
    #http://stackoverflow.com/questions/4915944/display-an-image-from-a-file-location
    "<img src='/root/ankishare3.1/assets/paste-23141283791373.jpg'>"  
  end

  def update
    @user = User.find(current_user)
    @card = Card.find(params[:id])
     deck_id = session[:deck_id] 
     cfront = params[:card][:card_front]
     cback  = params[:card][:card_back]
    if @card.update_card(cfront, cback)
      @user.increment!(:ecounter)
      redirect_to cards_show_path(:id => deck_id), notice: "Card has been successfully edited."
    else
      render action: "edit"
    end  
  end

  private
  
    def card_params
      params.require(:card).permit( :card_front, :card_back)
    end

end
