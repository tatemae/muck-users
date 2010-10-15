# include MuckUsers::Mailers::MuckUserMailer
module MuckUsers
  module Mailers
    module MuckUserMailer

      extend ActiveSupport::Concern
      
      def activation_confirmation(user)
        @user = user
        mail(:to => user.email, :subject => I18n.t('muck.users.activation_complete')) do |format|
          format.html
          format.text
        end
      end
  
      def activation_instructions(user)
        @user = user
        @account_activation_url = activate_url(user.perishable_token)
        mail(:to => user.email, :subject => I18n.t('muck.users.activation_instructions')) do |format|
          format.html
          format.text
        end
      end

      def password_not_active_instructions(user)
        @user = user
        mail(:to => user.email, :subject => I18n.t('muck.users.account_not_activated', :application_name => MuckEngine.configuration.application_name)) do |format|
          format.html
          format.text
        end
      end

      def password_reset_instructions(user)
        @user = user
        mail(:to => user.email, :subject => I18n.t('muck.users.password_reset_email_subject', :application_name => MuckEngine.configuration.application_name)) do |format|
          format.html
          format.text
        end
      end

      def welcome_notification(user)
        @user = user
        mail(:to => user.email, :subject => I18n.t('muck.users.welcome_email_subject', :application_name => MuckEngine.configuration.application_name)) do |format|
          format.html
          format.text
        end
      end

      def username_request(user)
        @user = user
        mail(:to => user.email, :subject => I18n.t('muck.users.request_username_subject', :application_name => MuckEngine.configuration.application_name)) do |format|
          format.html
          format.text
        end
      end

      def access_code(email, subject, message, code)
        @message = message
        @code = code
        mail(:to => email, :subject => subject) do |format|
          format.html
          format.text
        end
      end
    
    end
  end
end