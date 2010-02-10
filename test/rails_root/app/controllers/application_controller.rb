class ApplicationController < ActionController::Base
  include SslRequirement
  helper :all
  protect_from_forgery
  
  layout 'default'

  protected

    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access_required
      access_denied unless admin?
    end
  
    # only require ssl if it is turned on
    def ssl_required?
      if GlobalConfig.enable_ssl
        (self.class.read_inheritable_attribute(:ssl_required_actions) || []).include?(action_name.to_sym)
      else
        false
      end
    end

end
