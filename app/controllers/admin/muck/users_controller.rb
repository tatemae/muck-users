class Admin::Muck::UsersController < Admin::Muck::BaseController
  unloadable
    
  before_filter :get_user, :only => [:update, :destroy, :permissions]
  before_filter :setup_subnavigation
  
  def index
    respond_to do |format|
      format.html do
        @user_count = User.count
        @user_inactive_count = User.inactive_count
        @users = User.by_newest.paginate(:page => @page, :per_page => @per_page, :include => ['roles'])
        render :template => 'admin/users/index'
      end
      format.csv do
        @users = User.find(:all)
        headers["Content-Type"] = 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"users.csv\"" 
        render :layout => false 
      end
    end
  end

  def inactive
    @user_inactive_count = User.inactive_count
    @users = User.inactive.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/users/inactive' }
    end
  end
  
  def inactive_emails
    @user_inactive_count = User.inactive_count
    @users = User.inactive
    respond_to do |format|
      format.html { render :template => 'admin/users/inactive_emails' }
    end
  end
  
  def activate_all
    User.activate_all
    respond_to do |format|
      format.html do
        redirect_to inactive_admin_users_path
      end
    end
  end

  def search_results
    @users = User.do_search( params[:query] ).paginate(:page => @page, :per_page => @per_page )
  end

  def search
    search_results
    respond_to do |format|
      format.html do
        render :template => 'admin/users/index'
      end
    end
  end

  def ajax_search
    search_results
    respond_to do |format|
      format.html do
        render :partial => 'admin/users/table', :layout => false
      end
    end
  end

  def update
    
    if params[:deactivate]
      if is_me?(@user)
        message = translate("muck.users.cannot_deactivate_yourself")
      else
        if @user.deactivate!
          return update_activate(translate('muck.users.user_marked_inactive'))
        else
          message = translate('muck.users.user_not_deactivated_error')
        end
      end
    elsif params[:activate]
      if @user.activate!
        return update_activate(translate('muck.users.user_marked_active'))
      else
        message = translate('muck.users.user_not_activated_error')
      end
    else
      params[:user][:role_ids] ||= []
      if @user.update_attributes(params[:user])
        return update_permissions #(translate('muck.users.updated_permissions'))
      end
    end
    flash[:notice] = message
    output_admin_messages(@user)
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      self.current_user = @user
      flash[:notice] = t("muck.users.user_enabled")
    else
      flash[:error] = t("muck.users.user_enable_problem")
    end
    redirect_to :action => 'index'
  end
  
  def disable
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.update_attribute(:enabled, false)
      flash[:notice] = t("users.user_disabled")
    else
      flash[:error] = t("users.user_disable_problem")
    end
    redirect_to :action => 'index'
  end
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = translate('muck.users.user_successfully_deleted', :login => @user.login)
        redirect_to admin_users_path
      end
      format.xml  { head :ok }
      format.js { render :js => "jQuery('##{@user.dom_id('row')}').fadeOut();" }
    end
  end
  
  def permissions
    render :template => 'admin/users/permissions', :layout => false
  end
  
  protected

    def update_permissions(message = '')
      flash[:notice] = message unless message.blank?
      render :template => 'admin/users/update_permissions', :layout => false
    end
      
    def update_activate(message)
      flash[:notice] = message
      render :template => 'admin/users/update_activate', :layout => false
    end
    
    def get_user
      @user = User.find(params[:id])
    end
  
    def setup_subnavigation
      @sub_navigation_path = 'admin/users/user_navigation'
    end
  
end
