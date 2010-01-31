class Admin::Muck::RolesController < Admin::Muck::BaseController
  unloadable
  
  def index
    @roles = Role.by_alpha
    render :template => 'admin/roles/index'
  end

  def show
    @role = Role.find(params[:id])
    @users = @role.users.paginate(:page => @page, :per_page => @per_page)
    render :template => 'admin/roles/show'
  end

  def new
    @role = Role.new(params[:role])
    render :template => 'admin/roles/new', :layout => false
  end

  def create
    @role = Role.new(params[:role])
    if @role.save
      ajax_update_roles
    else
      output_admin_messages(@role)
    end
  end

  def edit
    @role = Role.find(params[:id])
    render :template => 'admin/roles/edit', :layout => false
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      ajax_update_roles
    else
      output_admin_messages(@role)
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if @role.rolename == 'administrator'
      flash[:notice] = translate('muck.users.cant_delete_administrator_role')
      output_admin_messages
    else
      if @role.delete
        flash[:notice] = translate('muck.users.role_deleted')
      else
        flash[:notice] = translate('muck.users.role_not_deleted')
      end
      respond_to do |format|
        format.html do
          redirect_to admin_roles_path
        end
        format.xml  { head :ok }
        format.js { render :text => "jQuery('##{@role.dom_id}').fadeOut();" }
      end
    end
  end

  protected
    
    def ajax_update_roles
      render :template => 'admin/roles/ajax_update_roles'
    end
    
end