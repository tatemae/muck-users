class Muck::AccessCodeRequestsController < ApplicationController

  layout 'popup'

  ssl_required :new, :create
  before_filter :not_logged_in_required, :except => [:create]

  def show
    render :template => 'access_code_requests/show'
  end
  
  def new
    @access_code_request = AccessCodeRequest.new
    @page_title = t('muck.users.request_access_code')
    render :template => 'access_code_requests/new'
  end
    
  def create
    if logged_in?
      @indicate_logged_in = true
      respond_to do |format|
        format.js do
          render :template => 'access_code_requests/create.js', :layout => false
        end
        format.html do
          flash[:notice] = translate('muck.users.beta_code_not_required')
          redirect_to user_path(current_user)
        end
      end
    else
      @access_code_request = AccessCodeRequest.create(params[:access_code_request])
      respond_to do |format|
        format.js do
          render :template => 'access_code_requests/create.js', :layout => false
        end
        format.html do
          @page_title = t('muck.users.request_access_code')
          if @access_code_request
            redirect_to access_code_request_path(@access_code_request)
          else
            render :template => "access_code_requests/new"
          end
        end
      end
    end
  end

end
