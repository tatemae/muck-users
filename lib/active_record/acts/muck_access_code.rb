module ActiveRecord
  module Acts #:nodoc:
    module MuckAccessCode #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_access_code(options = {})

          validates_presence_of :code, :uses, :use_limit, :expires_at
          validates_uniqueness_of :code

          has_many :users

          named_scope :newest, :order => 'access_codes.created_at DESC'
          named_scope :by_alpha, :order => 'access_codes.code ASC'
          named_scope :active, :conditions => 'access_codes.expires_at > Now() AND access_codes.uses <= use_limit'

          include ActiveRecord::Acts::MuckAccessCode::InstanceMethods
          extend ActiveRecord::Acts::MuckAccessCode::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

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
          AccessCode.find_by_code(code)
        end
        
      end
      
      module InstanceMethods
        
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
        
      end
    end
  end
end