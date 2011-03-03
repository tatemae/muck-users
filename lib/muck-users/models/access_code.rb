# include MuckUsers::Models::MuckAccessCode
module MuckUsers
  module Models
    module MuckAccessCode
      extend ActiveSupport::Concern
    
      included do
        
        validates_presence_of :code, :uses, :use_limit, :expires_at
        validates_uniqueness_of :code

        has_many :users

        scope :by_newest, order('access_codes.created_at DESC')
        scope :by_alpha, order('access_codes.code ASC')
        scope :active, where('access_codes.expires_at > Now() AND access_codes.uses <= use_limit')

        # Used to make bulk access code easier to deal with
        attr_accessor :emails, :subject, :message, :send_request_limit
                  
      end

      module ClassMethods

        def valid_code?(code)
          access_code = find_by_code(code)
          valid_code = access_code ? !access_code.overused? : false
          [access_code, valid_code]
        end
        
        def random_code
          code_length = 14 # will generate a code 15 chars long
          letters = ['B', 'C', 'D', 'F', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z']
          numbers = [2, 3, 4, 7, 9]
          promo_set = letters | numbers # combine arrays
          begin
            promo_code = promo_set.sort_by{rand}[0..code_length].to_s # randomize array and take the first 15 elements and make them a string
          end until !self.active_code?(promo_code)
          promo_code
        end
        
        # Checks the database to ensure the specified code is not taken
        def active_code?(code)
          self.find_by_code(code)
        end
        
      end
        
      def bulk_valid?
        errors.add(:emails, I18n.translate('muck.users.validation_are_required')) if self.emails.blank? && !self.send_requests
        errors.add(:subject, I18n.translate('muck.users.validation_is_required')) if self.subject.blank?
        errors.add(:message, I18n.translate('muck.users.validation_is_required')) if self.message.blank?
        raise ActiveRecord::RecordInvalid.new(self) if !errors.empty?
      end
      
      def use_code
        self.update_attribute(:uses, self.uses + 1)
      end

      def invalid?
        expired? || overused?
      end
      
      def overused?
        (self.uses >= self.use_limit) && !self.unlimited
      end
      
      def expired?
        self.expires_at? && self.expires_at < Time.now
      end

      def send_requests=(sr)
        @send_request = sr
      end

      def send_requests
        return false if @send_request == '0'
        return false if @send_request == 'false'
        return @send_request
      end
              
    end    
  end
end