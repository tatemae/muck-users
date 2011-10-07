# include MuckUsers::Models::MuckUser
module MuckUsers
  module Models
    module MuckUser
      extend ActiveSupport::Concern
      
      included do

        has_many :permissions
        has_many :roles, :through => :permissions

        scope :active, where("users.activated_at IS NOT NULL")
        scope :inactive, where("users.activated_at IS NULL")
        
        scope :by_newest, order("users.created_at DESC")
        scope :by_oldest, order("users.created_at ASC")
        scope :by_latest, order("users.updated_at DESC")
        scope :newer_than, lambda { |*args| where("users.created_at > ?", args.first || DateTime.now) }
        scope :older_than, lambda { |*args| where("users.created_at < ?", args.first || 1.day.ago.to_s(:db)) }
        
        scope :by_login_alpha, order("users.login ASC")
        scope :by_login, lambda { |*args| { :conditions => ["users.login LIKE ?", args.first + '%'] } }
        
        has_many :provided_access_codes, :class_name => "AccessCode", :foreign_key => "provided_by_id"
        belongs_to :access_code
        accepts_nested_attributes_for :access_code
        attr_accessor :access_code_code
        
        email_name_regex  = '[\w\.%\+\-]+'.freeze
        domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
        domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
        email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i

        before_save :lower_login
        
        validates_format_of :login, :with => /^[a-z0-9-]+$/i, :message => 'may only contain letters, numbers or a hyphen.'
        #validates_format_of :email, :with => email_regex, :message => 'does not look like a valid email address.'
        
        # prevents a user from submitting a crafted form that bypasses activation
        attr_protected :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count,
                       :failed_login_count, :last_request_at, :last_login_at, :current_login_at, :current_login_ip, :last_login_ip, 
                       :terms_of_service, :disabled_at, :activated_at, :created_at, :updated_at
      
        validates_terms_of_service if MuckUsers.configuration.validate_terms_of_service
      end

      module ClassMethods
        
        def inactive_count
          self.inactive.count
        end

        def activate_all
          self.update_all("activated_at = '#{Time.now}'", 'activated_at IS NULL')
        end

        # checks to see if a given login is already in the database
        def login_exists?(login)
          if self.find_by_login(login).nil?
            false
          else
            true
          end
        end

        # checks to see if a given email is already in the database
        def email_exists?(email)
          if self.find_by_email(email).nil?
            false
          else
            true
          end
        end
        
        def validates_terms_of_service
          validate(:accepts_terms_of_service?, :on => :create)
        end
        
        def parse_name(name)
          return '' if name.blank?
          names = name.split(' ')
          return '' if names.length <= 0
          return [names[0], names[0]] if names.length == 1
          [names[0], names.slice(1, names.length).join(' ')]
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
      
      # Build a random password
      def generate_password
        self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.email}--#{self.id}")
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
        @role_names = self.roles.map(&:rolename) if @role_names.blank?
        return false if @role_names.blank?
        (@role_names & test_rolenames).length > 0
      end
      
      # Add the user to a new role
      def add_to_role(rolename)
        @role_names = nil
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
      
      def add_exclude_fields(options = {})
        options ||= {}
        options[:except] ||= []
        options[:except] << :crypted_password << :salt << :remember_token << :remember_token_expires_at << :activation_code
        options[:except] << :activated_at << :password_reset_code << :enabled << :terms_of_service << :can_send_messages << :identity_url
        options[:except] << :tmp_password << :protected_profile << :public_profile << :disabled_at << :current_login_ip << :access_code_id
        options[:except] << :failed_login_count << :last_login_ip
        options[:except] << :password_salt << :perishable_token << :persistence_token << :single_access_token
        options
      end

      def to_xml(options = {})
        options = add_exclude_fields(options)
        super(options)
      end
      
      def as_json(options = {})
        options = add_exclude_fields(options)
        super(options)
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
        self.activated_at = Time.now.utc
        self.save!
      end
      
      def deactivate!
        self.activated_at = nil
        self.save!
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
      
      def accepts_terms_of_service?
        if !self.terms_of_service
          self.errors[:base] << I18n.translate('muck.users.terms_of_service_required')
        end
      end
      
    end 
  end
end
