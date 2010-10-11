require 'muck_users'
require 'rails'

module MuckUsers
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-users'
    end
    
    initializer 'muck_users.filter_paramters' do |app|     
      app.config.filter_parameters << :password
      app.config.filter_parameters << :password_confirmation
    end   

    initializer 'muck_users.add_admin_ui_links', :after => 'muck_engine.add_admin_ui_links' do
      # Add users to the dashboard
      MuckEngine.configuration.add_muck_dashboard_item('admin/users/dashboard_widget')
      # Add admin link for users and roles
      # MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_users'), '/admin/users', '/images/admin/user.gif') rescue nil
      # MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_access_codes'), '/admin/users', '/images/admin/user.gif') rescue nil
      MuckEngine.configuration.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_users'), '/admin/users')
      MuckEngine.configuration.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_roles'), '/admin/roles')
      MuckEngine.configuration.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_access_codes'), '/admin/access_codes')
    end
            
    initializer 'muck_users.controllers' do
      ActiveSupport.on_load(:action_controller) do
        include MuckUsers::AuthenticApplication
      end
    end
    
    initializer 'muck_users.helpers' do
      ActiveSupport.on_load(:action_view) do
        include MuckUsersHelper
      end
    end
    
    initializer 'muck_users.models' do
      ActiveSupport.on_load(:active_record) do
        include MuckUsers::SecureMethods
        include MuckUsers::Exceptions
      end
    end
    
  end
end