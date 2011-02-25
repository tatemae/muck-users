class Admin::Muck::AccessCodeRequestsController < Admin::Muck::BaseController
  
  def index
    @unfullfilled_requests = AccessCodeRequest.unfullfilled.by_newest.paginate(:page => @page, :per_page => @per_page)
    render :template => 'admin/access_code_requests/index'
  end
  
  def edit
    @access_code_request = AccessCodeRequest.find(params[:id])
    render :template => "admin/access_code_requests/edit", :layout => false
  end
  
  def send_code
    @access_code_request = AccessCodeRequest.find(params[:id])
    render :template => "admin/access_code_requests/send_code", :layout => false
  end
  
  def update
    debugger
    @access_code_request = AccessCodeRequest.find(params[:id])
    if params[:send_access_code]
      @success = @access_code_request.send_access_code(params[:subject], params[:message])
    else
      @success = @access_code_request.update_attributes(params[:access_code_request])
    end
    
    if @success
      ajax_update_access_code_request
    else
      output_admin_messages(@access_code_request)
    end
    
  rescue => ex
    flash[:error] = ex
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