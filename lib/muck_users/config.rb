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
    attr_accessor :recaptcha_pub_key  # key available from http://recaptcha.net
    attr_accessor :recaptcha_priv_key
    
    attr_accessor :let_users_delete_their_account   # Turn on/off ability for users to delete their own account. It is not recommended that you let 
                                                    # users delete their own accounts since the delete can cascade through the system with unknown results.

    def initialize
      self.automatically_activate = true
      self.automatically_login_after_account_create = true
      self.send_welcome = true
      self.use_recaptcha = false
      self.let_users_delete_their_account = false
    end
    
  end
end