class Muck::UsersController < ApplicationController

  ssl_required :show, :new, :edit, :create, :update
  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :login_required, :only => [:show, :edit, :update, :welcome]
  before_filter :check_administrator_role, :only => [:enable]

  def show
    @user = User.find(params[:id]) if params[:id]
    @user ||= current_user
    if @user == current_user
      @page_title = @user.to_param
      standard_response('show')
    else
      redirect_to public_user_path(@user)
    end
  end
  
  def welcome
    @page_title = t('muck.users.welcome')
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'users/welcome' }
    end
  end
  
  def activation_instructions
    @page_title = t('muck.users.welcome')
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'users/activation_instructions' }
    end
  end

  def new
    @page_title = t('muck.users.register_account', :application_name => MuckEngine.configuration.application_name)
    @user = User.new
    standard_response('new')
  end
  
  def edit
    @page_title = t('muck.users.update_profile')
    @user = admin? ? User.find(params[:id]) : current_user
    respond_to do |format|
      format.html { render :template => 'users/edit' }
    end
  end
    
  def create
    @page_title = t('muck.users.register_account', :application_name => MuckEngine.configuration.application_name)
    cookies.delete :auth_token
    @user = User.new(params[:user])
    setup_tos
    check_access_code
    check_recaptcha
    success, path = setup_user
    after_create_response(success, path)
  end

  def update
    @title = t("users.update_profile")
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.update_attributes(params[:user])
      flash[:notice] = t("muck.users.user_update")
      after_update_response(true)
    else
      after_update_response(false)
    end
  end

  def destroy
    return unless admin? || MuckUsers.configuration.let_users_delete_their_account
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.destroy
      flash[:notice] = t("muck.users.user_account_deleted")
    end
    after_destroy_response
  end

  def login_search
    if params[:q]
      @users = User.by_login_alpha.by_login(params[:q], :limit => params[:limit] || 100)
    else
      @users = User.by_login_alpha(:limit => params[:limit] || 100)
    end
    respond_to do |format|
      format.js { render :text => @users.collect{|user| user.login }.join("\n") }
      format.json { render :json => @users.collect{|user| { :login => user.login } }.to_json }
    end
  end
  
  def is_login_available
    result = t('muck.users.username_not_available')
    if params[:user_login].nil?
      result = ''
    elsif params[:user_login].empty?
      result = t('muck.users.login_empty')
    elsif !User.login_exists?(params[:user_login])
      @user = User.new(:login => params[:user_login])
      @user.valid? # we aren't interested in the output of this.
      if !@user.errors[:login].blank?
        result = "#{t('muck.users.invalid_username')} <br /> #{t('muck.users.username')} #{@user.errors[:login]}"
      else
        result = t('muck.users.username_available')
      end
    end
    respond_to do |format|
      if !@user.blank? && @user.errors[:login].blank? && !result.blank?
        format.html { render :partial => 'users/available', :locals => { :message => result } }
        format.js { render :partial => 'users/available', :locals => { :message => result } }
      else
        format.html { render :partial => 'users/unavailable', :locals => { :message => result } }
        format.js { render :partial => 'users/unavailable', :locals => { :message => result } }
      end
      
      #format.html { render :text => result }
      #format.js { render :text => result }
    end
  end

  def is_email_available
    if params[:user_email].nil?
      result = ''
    elsif params[:user_email].empty?
      result = t('muck.users.email_empty')
    elsif !User.email_exists?(params[:user_email])
      valid, errors = valid_email?(params[:user_email])
      if valid
        result = t('muck.users.email_available')
      else
        result = t('muck.users.email_invalid')
      end
    else
      recover_password_prompt = render_to_string :partial => 'users/recover_password_via_email_link', :locals => { :email => params[:user_email] }
      result = t('muck.users.email_not_available', :reset_password_help => recover_password_prompt)
      respond_to do |format|
        format.html { render :partial => 'users/unavailable', :locals => { :message => result } }
        format.js { render :partial => 'users/unavailable', :locals => { :message => result } }
      end
      return
    end
    respond_to do |format|
      if errors.blank? && ! result.nil?
        format.html { render :partial => 'users/available', :locals => { :message => result } }
        format.js { render :partial => 'users/available', :locals => { :message => result } }
      else
        format.html { render :partial => 'users/unavailable', :locals => { :message => result } }
        format.js { render :partial => 'users/unavailable', :locals => { :message => result } }
      end
    end
  end

  protected 

    def valid_email?(email)
      user = User.new(:email => email)
      user.valid?
      if !user.errors[:email].blank?
        [false, user.errors[:email]]
      else
        [true, '']
      end
    end
  
    def standard_response(template)
      respond_to do |format|
        format.html { render :template => "users/#{template}" }
        format.xml { render :xml => @user }
        format.json { render :json => { :success => true, :user => @user.as_json } }
      end
    end
  
    def after_create_response(success, local_uri = '')
      if success
        respond_to do |format|
          format.html { redirect_to local_uri }
          format.xml { render :xml => @user, :status => :created, :location => user_url(@user) }
          format.json { render :json => { :success => true, :user => @user.as_json } }
        end
      else
        respond_to do |format|
          format.html { render :template => "users/new" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
          format.json { render :json => { :success => false, :user => @user.as_json } }
        end
      end
    end
  
    # Sign up methods
    def check_access_code
      if MuckUsers.configuration.require_access_code
        access_code, valid_code = AccessCode.valid_code?(params[:user][:access_code_code])
        if valid_code
          @user.access_code = access_code
        else
          flash[:notice] = translate('muck.users.access_required_warning')
          raise Exceptions::InvalidAccessCode
        end
      end
    end
  
    def setup_tos
      # This value is not mass updatable and must be set manually.
      return unless params[:user] && params[:user][:terms_of_service]
      if params[:user][:terms_of_service] == '1' || params[:user][:terms_of_service] == true
        @user.terms_of_service = true
      end
    end
    
    def check_recaptcha
      if MuckUsers.configuration.use_recaptcha
        if !(verify_recaptcha(@user) && @user.valid?)
          raise ActiveRecord::RecordInvalid, @user
        end
      end
    end
  
    def setup_user
      if MuckUsers.configuration.automatically_activate
        if MuckUsers.configuration.automatically_login_after_account_create
          setup_user_login
        else
          setup_user_no_login
        end
      else
        setup_user_no_activate
      end
    end
  
    def setup_user_login
      path = ''
      success = false
      if @user.save
        @user.activate!
        UserSession.create(@user)
        send_welcome_email
        flash[:notice] = t('muck.users.thanks_sign_up')
        success = true
        path = signup_complete_path(@user)
      else
        success = false
      end
      [success, path]
    end
  
    def setup_user_no_login
      path = ''
      success = false
      if @user.save_without_session_maintenance
        @user.activate!
        send_welcome_email
        flash[:notice] = t('muck.users.thanks_sign_up_login')
        success = true
        path = signup_complete_login_required_path(@user)
      else
        success = false
      end
      [success, path]
    end
  
    def setup_user_no_activate
      path = ''
      success = false
      if @user.save_without_session_maintenance
        @user.deliver_activation_instructions!
        flash[:notice] = t('muck.users.thanks_sign_up_check')
        success = true
        path = signup_complete_activation_required_path(@user)
      else
        success = false
      end
      [success, path]
    end
  
    def send_welcome_email
      begin
        @user.deliver_welcome_email
      rescue Net::SMTPAuthenticationError => ex
        # TODO figure out what to do when email fails
        # @user.no_welcome_email = 
      end
    end
  
    def after_update_response(success, success_redirect = nil)
      if success
        respond_to do |format|
          format.html do
            if(success_redirect)
              redirect_to success_redirect
            elsif current_user == @user
              redirect_to user_path(@user)
            else # admin
              redirect_to public_user_path(@user)
            end  
          end
          format.xml{ head :ok }
        end
      else
        respond_to do |format|
          format.html { render :template => 'users/edit' }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
          format.json { render :json => { :success => success, :user => @user.as_json, :errors => @user.errors.as_json } }
        end
      end
    end
  
    def after_destroy_response(success_redirect = nil)
      respond_to do |format|
        format.html do
          flash[:notice] = t('muck.users.login_out_success')
          redirect_to success_redirect || login_url
        end
        format.xml { head :ok }
        format.json { render :json => { :success => true } }
      end
    end
  
    def permission_denied
      flash[:notice] = t('muck.users.permission_denied')
      respond_to do |format|
        format.html { redirect_to user_path(current_user) }
        format.xml { render :xml => t('muck.users.permission_denied'), :status => :unprocessable_entity }
        format.json { render :json => { :message => t('muck.users.permission_denied') } }
      end
    end

end
