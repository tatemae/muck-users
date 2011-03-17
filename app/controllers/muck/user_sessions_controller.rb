class Muck::UserSessionsController < ApplicationController
  
  ssl_required :new, :create
  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  def show
    if logged_in?
      redirect_to current_user
    else
      flash[:notice] = t('muck.users.login_fail')
      redirect_to login_path
    end
  end
  
  def new
    @title = t('muck.users.sign_in_title')
    @user_session = UserSession.new
    respond_to do |format|
      format.html { render :template => 'user_sessions/new' }
    end
  end
  
  def create
    @title = t('muck.users.sign_in_title')
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      after_create_response(result)
    end
  end
  
  def destroy
    @title = t('muck.users.sign_out_title')
    current_user.reset_single_access_token! if params[:reset_api_key]
    current_user_session.destroy
    flash[:notice] = t('muck.users.login_out_success')
    respond_to do |format|
      format.html { redirect_to logout_complete_path }
      format.json { render :json => { :logged_in => false, :message => t('muck.users.login_out_success') } }
    end
  end
  
  def login_check
    render :json => { :logged_in => logged_in? }
  end
  
  protected
  
    def after_create_response(success)
      if success
        respond_to do |format|
          format.html do
            flash[:notice] = t('muck.users.login_success')
            redirect_back_or_default(user_path(@user_session.user))
          end
          format.json { render :json => { :logged_in => true, :message => t('muck.users.login_success'), :user => @user.to_json } }
        end
      else
        respond_to do |format|
          format.html do
            flash[:notice] = t('muck.users.login_fail')
            render :template => 'user_sessions/new'
          end
          format.json { render :json => { :logged_in => false, :message => t('muck.users.login_fail') } }
        end
      end
    end
  
    # override redirect by adding a route like this:
    # map.logout_complete '/login', :controller => 'user_session', :action => 'new'
    def after_destroy_response
      respond_to do |format|
        format.html { redirect_to logout_complete_path }
      end
    end
  
end