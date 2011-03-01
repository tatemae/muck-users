Rails.application.routes.draw do
  
  # users
  resources :users, :controller => 'muck/users' do
    collection do
      post :is_login_available
      post :is_email_available
      get :login_search
    end
    member do
      get :welcome 
      get :activation_instructions
    end
  end
                    
  match '/signup'                        => 'muck/users#new',                     :as => :signup, :constraints => { :protocol => muck_routes_protocol }
  match '/users/signup_complete/:id'     => 'muck/users#welcome',                 :as => :signup_complete
  match '/users/activation_complete/:id' => 'muck/users#welcome',                 :as => :activation_complete
  match '/signup_complete_activate/:id'  => 'muck/users#activation_instructions', :as => :signup_complete_activation_required
  match 'account'                        => 'muck/users#show',                    :as => :account
  match 'current_user'                   => 'muck/users#show'
  
  # activations
  resources :activations, :controller => 'muck/activations'
  match '/activate/:activation_code' => 'muck/activations#new', :as => :activate
  
  # passwords
  resources :password_resets, :controller => 'muck/password_resets'
  match '/forgot_password'    => 'muck/password_resets#new',    :as => :forgot_password, :constraints => { :protocol => muck_routes_protocol }
  match '/reset_password/:id' => 'muck/password_resets#edit',   :as => :reset_password, :constraints => { :protocol => muck_routes_protocol }
  match '/reset_password/:id' => 'muck/password_resets#update', :as => :reset_password, :constraints => { :protocol => muck_routes_protocol }, :method => 'put'

  # username
  resource :username_request, :controller => 'muck/username_request'
  match '/forgot_username' => 'muck/username_request#new', :as => :forgot_username, :constraints => { :protocol => muck_routes_protocol }
  
  # sessions
  resource :user_session, :controller => 'muck/user_sessions'
  match '/login'                     => 'muck/user_sessions#new',     :as => :login, :constraints => { :protocol => muck_routes_protocol }
  match '/logout'                    => 'muck/user_sessions#destroy', :as => :logout, :constraints => { :protocol => muck_routes_protocol }
  match '/signup_complete_login/:id' => 'muck/user_sessions#new',     :as => :signup_complete_login_required
  match '/login'                     => 'muck/user_sessions#new',     :as => :logout_complete
  match '/login_check'               => 'muck/user_sessions#login_check'
  
  # Access codes
  resources :access_code_requests, :controller => 'muck/access_code_requests'
  
  # admin
  namespace :admin do
    resources :users, :controller => 'muck/users' do
      collection do
        get :inactive
        post :search
        get :inactive_emails
        get :activate_all
      end
      member do
        get :permissions
      end
    end
    resources :roles, :controller => 'muck/roles'
    resources :access_code_requests, :controller => 'muck/access_code_requests' do
      member do
        get :send_code
      end
    end
    resources :access_codes, :controller => 'muck/access_codes' do
      collection do
        get :bulk
        post :bulk_create
      end
    end
  end
  
end
