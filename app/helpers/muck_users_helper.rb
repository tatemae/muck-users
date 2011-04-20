module MuckUsersHelper
  
  # Render a basic user registration form
  def signup_form(user, redirect_to = nil, options = {}, &block)
    options[:html] = {} if options[:html].nil?
    options[:title] = nil if options[:title].blank?
    options[:subtitle] = nil if options[:subtitle].blank?
    if(params[:access_code] || session[:access_code])
      access_code = params[:access_code] || session[:access_code]
      session[:access_code] = access_code
      @access_code = AccessCode.find_by_code(access_code)
      if @access_code
        user.email = @access_code.sent_to if user
      else
        @access_code_not_found = true
      end
    end
    
    if params[:access_code].blank?
      @access_code_help = '<p id="access_code_help" class="attention">' + 
        translate('muck.users.access_code_help', 
          :access_request_anchor => %Q{<a class="fancy-access-request iframe" href="#{new_access_code_request_path}">},
          :access_request_anchor_end => "</a>") + '<p>'.html_safe
	  end
	  
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
  
  def active_class(user)
    if user.active?
      'user-active'
    else
      'user-inactive'
    end
  end
  
end