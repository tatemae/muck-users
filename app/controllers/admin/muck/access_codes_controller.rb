class Admin::Muck::AccessCodesController < Admin::Muck::BaseController
  
  def index
    @codes = AccessCode.by_alpha.paginate(:page => @page, :per_page => @per_page)
    render :template => 'admin/access_codes/index'
  end

  def show
    @access_code = AccessCode.find(params[:id])
    render :template => 'admin/access_codes/show'
  end
  
  def new
    render :template => 'admin/access_codes/new', :layout => false
  end
  
  def create
    @access_code = AccessCode.new(params[:access_code])
    if @access_code.save
      ajax_create_access_code
    else
      output_admin_messages(@access_code)
    end
  end
  
  def bulk
    @access_code = AccessCode.new
    @access_code.code = AccessCode.random_code
    @access_code_requests_count = AccessCodeRequest.unfullfilled.count
    render :template => 'admin/access_codes/bulk'
  end
  
  def bulk_create
    @access_code = AccessCode.new(params[:access_code])
    @access_code.bulk_valid?
    if send_requests = @access_code.send_requests
      access_code_requests = AccessCodeRequest.get_requests(@access_code.send_request_limit)
      emails = access_code_requests.map(&:email)
    else
      emails = @access_code.emails.split(',')
    end
    use_random_code = @access_code.code.blank?
    emails.each do |email|
      if use_random_code
        # need to build a new access code for each email
        @access_code = AccessCode.new(params[:access_code])
        @access_code.unlimited = false
        @access_code.use_limit = 1
        @access_code.uses = 0
        @access_code.code = AccessCode.random_code
        @access_code.save!
      end
      UserMailer.access_code(email, @access_code.subject, @access_code.message, @access_code.code).deliver
    end
    AccessCodeRequest.mark_fullfilled(access_code_requests) if access_code_requests
    flash[:notice] = translate('muck.users.bulk_access_codes_created', :email_count => emails.count)
    redirect_to bulk_admin_access_codes_path

  rescue ActiveRecord::RecordInvalid => ex
    @access_code_requests_count = AccessCodeRequest.unfullfilled.count
    render :template => "admin/access_codes/bulk"
  end

  def edit
    @access_code = AccessCode.find(params[:id])
    render :template => "admin/access_codes/edit", :layout => false
  end

  def update
    @access_code = AccessCode.find(params[:id])
    if @access_code.update_attributes(params[:access_code])
      ajax_update_access_code
    else
      output_admin_messages(@access_code)
    end
  end

  def destroy
    @access_code = AccessCode.find(params[:id])
    if @access_code.users.length <= 0
      success = @access_code.destroy
      flash[:notice] = translate('muck.users.access_code_delete_error') unless success
    else
      flash[:notice] = translate('muck.users.access_code_delete_problem')
    end
    respond_to do |format|
      format.html { redirect_to admin_access_codes_path }
      format.js do
        if success
          render :template => 'admin/access_codes/destroy', :layout => false
        else
          output_admin_messages
        end
      end
    end
    
  end
  
  protected
  
    def ajax_update_access_code
      render :template => 'admin/access_codes/ajax_update_access_code'
    end
    
    def ajax_create_access_code
      render :template => 'admin/access_codes/ajax_create_access_code'
    end
      
end
