module MuckUsers
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :automatically_activate                   # Automatically active a users account during registration. If true the user won't get a 
                                                            # 'confirm account' email. If false then the user will need to confirm their account via an email.
    attr_accessor :automatically_login_after_account_create # Automatically log the user in after they have setup their account. This should be false if you 
                                                            # require them to activate their account.
    attr_accessor :send_welcome                             # Send out a welcome email after the user has signed up.

    # if you use recaptcha you will need to also provide a public and private key available from http://recaptcha.net.
    attr_accessor :use_recaptcha      # This will turn on recaptcha during registration. This is an alternative to sending the 
                                      # user a confirm email and can help reduce spam registrations.
    
    attr_accessor :let_users_delete_their_account   # Turn on/off ability for users to delete their own account. It is not recommended that you let 
                                                    # users delete their own accounts since the delete can cascade through the system with unknown results.

    attr_accessor :require_access_code        # Require that the user have an access code to be able to sign up.
    attr_accessor :validate_terms_of_service  # Require that the accept terms of service before signing up.
    
    attr_accessor :send_access_code_request_confirm # Determines whether or not to send a confirmation email after a user requests an access code.
    attr_accessor :use_http_status_failures         # This only applies to json requests
    
    def initialize
      self.use_http_status_failures = false
      self.automatically_activate = true
      self.automatically_login_after_account_create = true
      self.send_welcome = true
      self.use_recaptcha = false
      self.let_users_delete_their_account = false
      self.require_access_code = false
      self.validate_terms_of_service = false
      self.send_access_code_request_confirm = false
    end
    
  end
end