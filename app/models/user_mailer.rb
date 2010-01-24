class UserMailer < ActionMailer::Base
  unloadable
  
  layout 'email_default'
  default_url_options[:host] = GlobalConfig.application_url
  
  def activation_confirmation(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.activation_complete')
    body      :user => user
  end
  
  def activation_instructions(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.activation_instructions')
    body      :user => user,
              :account_activation_url => activate_url(user.perishable_token)
  end

  def password_not_active_instructions(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.account_not_activated', :application_name => GlobalConfig.application_name)
    body      :user => user
  end

  def password_reset_instructions(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.password_reset_email_subject', :application_name => GlobalConfig.application_name)
    body      :user => user
  end

  def welcome_notification(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.welcome_email_subject', :application_name => GlobalConfig.application_name)
    body      :user => user,
              :application_name => GlobalConfig.application_name
  end

  def username_request(user)
    muck_setup_email(user)
    subject   I18n.t('muck.users.request_username_subject', :application_name => GlobalConfig.application_name)
    body      :user => user,
              :application_name => GlobalConfig.application_name
  end

  def access_code(email, subject, message, code)
    muck_setup_email(user)
    subject       subject
    body          :message => message, :code => code
    content_type  "text/html"
  end
    
end
