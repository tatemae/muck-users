module MuckUsers
  module Models
    module User
      extend ActiveSupport::Concern
      
      included do

        has_many :permissions
        has_many :roles, :through => :permissions

        scope :by_newest, order("created_at DESC")
        scope :active, where("activated_at IS NOT NULL")
        scope :inactive, where("activated_at IS NULL")
        scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
        scope :by_login_alpha, order("login ASC")
        scope :by_login, lambda { |*args| { :conditions => ["login LIKE ?", args.first + '%'] } }
        
        belongs_to :access_code
        accepts_nested_attributes_for :access_code
        attr_accessor :access_code_code
        
        email_name_regex  = '[\w\.%\+\-]+'.freeze
        domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
        domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
        email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i

        before_save :lower_login
        
        validates_format_of :login, :with => /^[a-z0-9-]+$/i, :message => 'may only contain letters, numbers or a hyphen.'
        validates_format_of :email, :with => email_regex, :message => 'does not look like a valid email address.'
        
        # prevents a user from submitting a crafted form that bypasses activation
        attr_protected :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count,
                       :failed_login_count, :last_request_at, :last_login_at, :current_login_at, :current_login_ip, :last_login_ip, 
                       :terms_of_service, :time_zone, :disabled_at, :activated_at, :created_at, :updated_at
      
      end

      module ClassMethods
        def do_search(query)
          User.search(query)
        end
        
        def inactive_count
          User.count :conditions => "activated_at is null"
        end

        def activate_all
          User.update_all("activated_at = '#{Time.now}'", 'activated_at IS NULL')
        end

        # checks to see if a given login is already in the database
        def login_exists?(login)
          if User.find_by_login(login).nil?
            false
          else
            true
          end
        end

        # checks to see if a given email is already in the database
        def email_exists?(email)
          if User.find_by_email(email).nil?
            false
          else
            true
          end
        end
          
      end
      
      def deliver_welcome_email
        UserMailer.welcome_notification(self).deliver if MuckUsers.configuration.send_welcome
      end
      
      def deliver_activation_confirmation!
        reset_perishable_token!
        UserMailer.activation_confirmation(self).deliver
      end
      
      def deliver_activation_instructions!
        reset_perishable_token!
        UserMailer.activation_instructions(self).deliver
      end
      
      def deliver_password_reset_instructions!
        if self.active?
          reset_perishable_token!  
          UserMailer.password_reset_instructions(self).deliver
        else
          UserMailer.password_not_active_instructions(self).deliver
        end
      end

      def deliver_username_request!
        UserMailer.username_request(self).deliver
      end
      
      # Since password reset doesn't need to change openid_identifier,
      # we save without block as usual.
      def reset_password!(user)
        self.password = user[:password]
        self.password_confirmation = user[:password_confirmation]
        save
      end
      
      def is_in_role?(object, roles)
        raise 'not implemented'
      end
      
      def has_role?(rolename)
        self.any_role?(rolename)
      end

      def any_role?(*test_rolenames)
        test_rolenames = [test_rolenames] unless test_rolenames.is_a?(Array)
        test_rolenames.flatten!
        @role_names ||= self.roles.map(&:rolename)
        return false if @role_names.blank?
        (@role_names & test_rolenames).length > 0
      end
      
      # Add the user to a new role
      def add_to_role(rolename)
        role = Role.find_or_create_by_rolename(rolename)
        self.roles << role if !self.roles.include?(role) # Make sure that the user can only be put into a role once
      end
      
      def admin?
        self.has_role?('administrator')
      end

      def can_edit?(user)
        return false if user.nil?
        self.id == user.id || user.admin?
      end
              
      def to_xml(options = {})
        options[:except] ||= []
        options[:except] << :email << :crypted_password << :salt << :remember_token << :remember_token_expires_at << :activation_code
        options[:except] << :activated_at << :password_reset_code << :enabled << :terms_of_service << :can_send_messages << :identity_url
        options[:except] << :tmp_password << :protected_profile << :public_profile    
        options[:except] << :password_salt << :perishable_token << :persistence_token << :single_access_token
        super
      end
              
      # Authlogic automatically executes the following methods
      def active?
        !activated_at.blank?
      end

      # def approved?
      # end
      # 
      # def confirmed?
      # end
      
      #lowercase all logins
      def lower_login
        self.login = self.login.nil? ? nil : self.login.downcase 
      end
              
      def activate!
        self.update_attribute(:activated_at, Time.now.utc)
      end
      
      def deactivate!
        self.update_attribute(:activated_at, nil)
      end
      
      def short_name
        CGI::escapeHTML(self.first_name) || self.display_name
      end

      def full_name
        if self.first_name.blank? && self.last_name.blank?
          self.display_name rescue 'Deleted user'
        else
          ((CGI::escapeHTML(self.first_name) || '') + ' ' + (CGI::escapeHTML(self.last_name) || '')).strip
        end
      end

      def display_name
        CGI::escapeHTML(self.login)
      end
      
      def validates_terms_of_service
        validate_on_create :accepts_terms_of_service?
      end
      
      def accepts_terms_of_service?
        if !self.terms_of_service
          errors.add_to_base(I18n.translate('muck.users.terms_of_service_required'))
        end
      end
      
    end 
  end
end
