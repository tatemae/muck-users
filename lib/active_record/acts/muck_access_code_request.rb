module ActiveRecord
  module Acts #:nodoc:
    module MuckAccessCodeRequest #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_access_code_request(options = {})

          validates_presence_of :email
          validates_uniqueness_of :email
          
          named_scope :unfilled, :conditions => 'access_code_requests.code_sent_at IS NULL'
          
          include ActiveRecord::Acts::MuckAccessCodeRequest::InstanceMethods
          extend ActiveRecord::Acts::MuckAccessCodeRequest::SingletonMethods
          
        end
      end

      module SingletonMethods

      end
      
      module InstanceMethods
       
      end

    end
  end
end