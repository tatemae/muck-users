class Muck::AccessCodeRequestsController < ApplicationController

  layout 'popup'

  ssl_required :new, :create
  before_filter :not_logged_in_required

  def show
    render :template => 'access_code_requests/show'
  end
  
  def new
    @page_title = t('muck.users.request_access_code')
    render :template => 'access_code_requests/new'
  end
    
  def create
    @page_title = t('muck.users.request_access_code')
    @access_code_request = AccessCodeRequest.create(params[:access_code_request])
    respond_to do |format|
      format.js do
        render :template => 'access_code_requests/create.js', :layout => false
      end
      format.html do
        if @access_code_request
          redirect_to access_code_request_path(@access_code_request)
        else
          render :template => "access_code_requests/new"
        end
      end
    end
        
  end

end
