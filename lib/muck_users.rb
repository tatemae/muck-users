require 'muck_users/exceptions'
require 'active_record/secure_methods'

ActionController::Base.send :include, ActionController::AuthenticApplication
ActiveRecord::Base.send :include, ActiveRecord::SecureMethods
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckUser }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckAccessCode }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckAccessCodeRequest }
ActiveRecord::Base.class_eval { include MuckUsers::Exceptions }
ActionController::Base.send :helper, MuckUsersHelper

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

# Add admin link for users and roles
# MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_users'), '/admin/users', '/images/admin/user.gif') rescue nil
# MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_access_codes'), '/admin/users', '/images/admin/user.gif') rescue nil
MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_users'), '/admin/users') rescue nil
MuckEngine.add_muck_admin_nav_item(I18n.translate('muck.engine.admin_access_codes'), '/admin/users') rescue nil

# Add users to the dashboard
MuckEngine.add_muck_dashboard_item('admin/users/dashboard_widget') rescue nil
