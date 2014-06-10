PaymoneyAdministration::Application.routes.draw do
	#root :to => "users#dashboard"
  root :to => redirect("/users/sign_in")
  #devise_scope :user do
		#root to: "devise/sessions#new"
	#end
  
  resources :statuses
  
  
  devise_for :users, :controllers => {:registrations => "devise/registrations", :sessions => "devise/sessions", :passwords => "devise/passwords"}
  
  devise_scope :user do
  	get 'dashboard' => 'devise/registrations#new', :as => :administrator_dashboard
  	get "user/edit_profile/:id" => "devise/registrations#edit", :as => :edit_user_profile
  	patch 'user/update_profile' => 'devise/registrations#update_profile', :as => :update_user_profile
  end
  
  get 'user/search' => 'users#search', :as => :search_user
  get 'user/enable_profile/:id' => 'users#enable_profile', :as => :enable_user_profile
  get 'user/disable_profile/:id' => 'users#disable_profile', :as => :disable_user_profile 
  
  get "liste-des-comptes-actives" => "accounts#index", as: :enabled_accounts_list
  get "liste-des-comptes-desactives" => "accounts#disabled_accounts", as: :disabled_accounts_list
  get "liste-des-depots" => "accounts#credits", as: :list_credits
  get "liste-des-retraits" => "accounts#debits", as: :list_debits
  get "activer-un-compte/:account_id" => "accounts#enable_account", as: :enable_account
  get "desactiver-un-compte/:account_id" => "accounts#disable_account", as: :disable_account
  post "rechercher-un-compte" => "accounts#search"
  get "rechercher-un-compte" => "accounts#search"
  
  get "auditeur-liste-des-profils" => "profiles#auditor_index", as: :auditor_index
  get "liste-des-utilisateurs-par-profil/:profile_id" => "profiles#users_per_profile", as: :users_per_profile
  get "profile/custom" => "profiles#custom_profiles", as: :custom_profiles_dashboard
  get "profiles" => "profiles#index", as: :profiles
  post "profile/create" => "profiles#create"
  get "profile/create" => "profiles#index"
  get "profile/edit/:id" => "profiles#edit", as: :edit_profile
  post "profile/update" => "profiles#update"
  get "profile/update" => "profiles#index"
  get "profiles/edit_rights" => "profiles#edit_rights", as: :edit_profiles_rights
  get "profile/right/enable_create_user/:id" => "profiles#enable_create_user_right", as: :enable_create_user_right
  get "profile/right/disable_create_user/:id" => "profiles#disable_create_user_right", as: :disable_create_user_right
  get "profile/right/enable_edit_user_data/:id" => "profiles#enable_edit_user_data_right", as: :enable_edit_user_data_right
  get "profile/right/disable_edit_user_data/:id" => "profiles#disable_edit_user_data_right", as: :disable_edit_user_data_right
  
  get "profile/right/enable_create_profile/:id" => "profiles#enable_create_profile_right", as: :enable_create_profile_right
  get "profile/right/disable_create_profile/:id" => "profiles#disable_create_profile_right", as: :disable_create_profile_right
  
  get "profile/right/enable_edit_profile/:id" => "profiles#enable_edit_profile_right", as: :enable_edit_profile_right
  get "profile/right/disable_edit_profile/:id" => "profiles#disable_edit_profile_right", as: :disable_edit_profile_right
  
  get "profile/right/enable_view_transactions/:id" => "profiles#enable_view_transactions_right", as: :enable_view_transactions_right
  get "profile/right/disable_view_transactions/:id" => "profiles#disable_view_transactions_right", as: :disable_view_transactions_right
  
  get "profile/right/enable_disable_account/:id" => "profiles#enable_disable_account_right", as: :enable_disable_account_right
  get "profile/right/disable_disable_account/:id" => "profiles#disable_disable_account_right", as: :disable_disable_account_right
  
  #devise_scope :user do
  	#match '/users/sign_out' => 'devise/sessions#destroy'
  	#match 'create_user' => 'devise/registrations#new', :as => :dashboard_administrator
  	#match "users/search_ajax" => "devise/users#search_ajax"
  	#match "users/get_directions" => "devise/users#get_directions"
  	#match "users/get_workshops" => "devise/users#get_workshops"
  	#match "user/edit" => "devise/registrations#edit", :as => :edit_user
  	#match "users/enable" => "devise/users#enable", :as => :enable_user
  	#match "users/disable" => "devise/users#disable", :as => :disable_user
  	#match "users/delete" => "devise/users#delete", :as => :delete_user
  	#match 'user/update' => 'devise/users#update', :as => :update_user
  #end
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
