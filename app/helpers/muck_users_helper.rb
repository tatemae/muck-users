module MuckUsersHelper
  
  # Render a basic user registration form
  def signup_form(user, redirect_to = nil, options = {}, &block)
    options[:html] = {} if options[:html].nil?
    options[:title] = nil if options[:title].blank?
    options[:subtitle] = nil if options[:subtitle].blank?
    raw_block_to_partial('users/signup_form', options.merge(:user => user, :redirect_to => redirect_to), &block)
  end
  
  def signin_form(options = {}, &block)
    options[:html] = {} if options[:html].nil?
    options[:title] = nil if options[:title].blank?
    options[:exclude_register_link] = false if options[:exclude_register_link].blank?    
    options[:exclude_forgot_password_link] = false if options[:exclude_forgot_password_link].blank?
    options[:exclude_forgot_username_link] = false if options[:exclude_forgot_username_link].blank?
    raw_block_to_partial('user_sessions/form', options, &block)
  end
  
  # Sign up javascript is not required but will add script to the sign up form which will make ajax calls
  # that indicate to the user whether or not the login and email they choose have already been taken.
  def signup_form_javascript
    render :partial => 'users/signup_form_javascript'
  end
  
end