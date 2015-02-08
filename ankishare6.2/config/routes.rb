Rails.application.routes.draw do
  get 'profile/index'

  get 'profile/show'
  
  get 'profile/faq'

  devise_for :users
  get 'decks/index'

  get 'decks/new'

  get 'decks/load_from_apkg'

  get 'decks/edit'
  # route for downloading the deck.
  get 'decks/repackage'

  get 'cards/index'

  get 'cards/view'

  get 'cards/show'
  # Following routes added by Vamsi Koduru
  # Follwoing routes added to serve image files
  match '/cards/:filename' => 'cards#sendimg', via: :get 
  # route for editing cards
  match '/cards/:id/edit' => 'cards#edit', via: :get
  # routes for displaying images within the card edit
  match '/cards/:id/:filename' => 'cards#sendimg', via: :get 

  mount Ckeditor::Engine => '/ckeditor'
  resources :cards 

   resources :decks do
    collection do
      get 'load_from_apkg'
    end
   end 
  
  root :to => 'decks#index'

	devise_scope :user do
		get "/login" => "devise/sessions#new"
	      end 
  
	devise_scope :user do
		delete "/logout" => "devise/sessions#destory"
	end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
