ActionController::Routing::Routes.draw do |map|
  
  # users
  map.resources :users, :controller => 'muck/users',
                        :member => { :enable => :put, :welcome => :get, :activation_instructions => :get },
                        :collection => { :is_login_available => :post, :is_email_available => :post }
  
  map.with_options(:controller => 'muck/users') do |users| 
    users.signup "/signup",  :action => 'new', :requirements => {:protocol => muck_routes_protocol}
    users.signup_complete "/users/signup_complete/:id",  :action => 'welcome'
    users.activation_complete "/users/activation_complete/:id", :action => 'welcome'
    users.signup_complete_activation_required '/signup_complete_activate/:id', :action => 'activation_instructions'
    users.is_login_available '/is_login_available', :action => 'is_login_available'
    users.is_email_available '/is_email_available', :action => 'is_email_available'
    users.account "account", :action => 'show'
  end
  
  # activations
  map.resources :activations, :controller => 'muck/activations'
  map.with_options(:controller => 'muck/activations') do |activations|
    activations.activate '/activate/:activation_code', :action => 'new'
  end
  
  # passwords
  map.resources :password_resets, :controller => 'muck/password_resets'
  
  map.with_options(:controller => 'muck/password_resets') do |password_resets|
    password_resets.forgot_password "/forgot_password", :action => 'new', :requirements => {:protocol => muck_routes_protocol}
    password_resets.reset_password "/reset_password/:id", :action => 'edit', :requirements => {:protocol => muck_routes_protocol}
    password_resets.reset_password "/reset_password/:id", :action => 'update', :method => 'put', :requirements => {:protocol => muck_routes_protocol}
  end

  # username
  map.resource :username_request, :controller => 'muck/username_request'

  map.with_options(:controller => 'muck/username_request') do |username_request|
    username_request.forgot_username "/forgot_username", :action => 'new', :requirements => {:protocol => muck_routes_protocol}
  end
  
  # sessions
  map.resource :user_session, :controller => 'muck/user_sessions'
  map.with_options(:controller => 'muck/user_sessions') do |user_sessions|
    user_sessions.login "/login", :action => 'new', :requirements => {:protocol => muck_routes_protocol}
    user_sessions.logout "/logout", :action => 'destroy', :requirements => {:protocol => muck_routes_protocol}
    user_sessions.signup_complete_login_required '/signup_complete_login/:id', :action => 'new'
  end
  
  # Access codes
  map.resources :access_code_requests, :controller => 'muck/access_code_requests'

  # page a user is taken to when they log out
  map.logout_complete '/login', :controller => 'user_session', :action => 'new'
  
  # admin
  map.namespace :admin do |a|
    a.resources :users, :controller => 'muck/users', :member => { :permissions => :get }, :collection => { :inactive => :get, :inactive_emails => :get, :activate_all => :get, :search => :post, :ajax_search => :post }
    a.resources :roles, :controller => 'muck/roles'
    a.resources :access_codes, :controller => 'muck/access_codes', :collection => {:bulk => :get, :bulk_create => :post}
  end

end
