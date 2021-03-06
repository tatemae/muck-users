class Admin::Muck::AccessCodeRequestsController < Admin::Muck::BaseController
  
  def index
    if params[:fullfilled]
      @title = translate('muck.users.fullfilled_access_code_requests')
      @access_code_requests = AccessCodeRequest.fullfilled.by_newest.paginate(:page => @page, :per_page => @per_page)
    else
      @title = translate('muck.users.unfullfilled_access_code_requests')
      @access_code_requests = AccessCodeRequest.unfullfilled.by_newest.paginate(:page => @page, :per_page => @per_page)
    end
    render :template => 'admin/access_code_requests/index'
  end
  
  def search
    @is_search = true
    query = "%#{params[:query]}%"
    if params[:fullfilled]
      @access_code_requests = AccessCodeRequest.where("name LIKE ? OR email LIKE ?", query, query).fullfilled.by_newest.paginate(:page => @page, :per_page => @per_page)
    else
      @access_code_requests = AccessCodeRequest.where("name LIKE ? OR email LIKE ?", query, query).unfullfilled.by_newest.paginate(:page => @page, :per_page => @per_page)
    end
    respond_to do |format|
      format.html { render :template => 'admin/access_code_requests/index' }
    end
  end
  
  def edit
    @access_code_request = AccessCodeRequest.find(params[:id])
    render :template => "admin/access_code_requests/edit", :layout => false
  end
  
  def send_code
    @subject ||= params[:subject]
    @message ||= params[:message]
    @expires_at = 1.year.from_now
    @access_code_request = AccessCodeRequest.find(params[:id])
    render :template => "admin/access_code_requests/send_code", :layout => false
  end
  
  def update
    @access_code_request = AccessCodeRequest.find(params[:id])
    if params[:send_access_code]
      @success = @access_code_request.send_access_code(params[:subject], params[:message], params[:expires_at])
    else
      @success = @access_code_request.update_attributes(params[:access_code_request])
    end
    
    if @success
      ajax_update_access_code_request
    else
      output_admin_messages(@access_code_request)
    end
    
  rescue => ex
    flash[:error] = ex.to_s
    output_admin_messages
  end
  
  def destroy
    @access_code_request = AccessCodeRequest.find(params[:id])
    @success = @access_code_request.destroy
    respond_to do |format|
      format.html { redirect_to admin_access_code_requests_path }
      format.js do
        if @success
          render :template => 'admin/access_code_requests/destroy', :layout => false
        else
          output_admin_messages
        end
      end
    end
  end
  
  protected
  
    def ajax_update_access_code_request
      render :template => 'admin/access_code_requests/ajax_update_access_code_request'
    end
    
end