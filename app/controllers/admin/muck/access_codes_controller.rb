class Admin::AccessCodesController < Admin::Muck::BaseController

  before_filter :setup_access_code, :except => [:index, :new, :create]
  
  def index
    @codes = AccessCode.by_alpha.paginate(:page => @page, :per_page => @per_page)
    render :template => 'admin/access_codes/index'
  end

  def show
    render :template => 'admin/access_codes/show'
  end
  
  def new
    render :template => 'admin/access_codes/new'
  end
  
  def create
    @access_code = AccessCode.new(params[:access_code])
    respond_to do |format|
      if @access_code.save
        flash[:notice] = 'Access Code was successfully added'
        format.html { redirect_to admin_access_code_path(@access_code) }
      else
        format.html { render :action => 'admin/access_codes/new' }
      end
    end
  end
  
  def bulk
    @access_code = AccessCode.new
    @access_code.code = AccessCode.random_code
  end
  
  def bulk_create
    emails = params[:emails].split(',')
    emails.each do |email|
      @access_code = AccessCode.new(params[:access_code])
      @access_code.unlimited = false
      @access_code.use_limit = 1
      @access_code.uses = 0
      @access_code.code = AccessCode.random_code
      @access_code.save!
      MessageMailer.deliver_access_code(email, params[:subject], params[:message], @access_code.code)
    end    
    redirect_to admin_access_codes_path
  rescue ActiveRecord::RecordInvalid => ex
    render :action => :bulk
  end
  
  def edit
  end
  
  def update
    if @access_code.update_attributes(params[:access_code])
      redirect_to { redirect_to(admin_access_code_path(@access_code)) }
    else
      flash[:notice] = 'There was a problem updating the access code.'
      format.html { render :action => "edit" }
    end
  end

  def destroy
    if @access_code.users.length <= 0
      @access_code.destroy
      flash[:notice] = "Deleted access code."
    else
      flash[:notice] = "Cannot delete access code it has users associated with it."
    end
    respond_to do |format|
      format.html { redirect_to admin_access_codes_path }
    end
  end
  
  protected
    def setup_access_code
      @access_code = AccessCode.find(params[:id])
    end
end
