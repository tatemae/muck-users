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
          
          named_scope :unfullfilled, :conditions => 'access_code_requests.code_sent_at IS NULL'
          named_scope :by_newest, :order => "created_at DESC"
          named_scope :by_oldest, :order => "created_at ASC"
          
          include ActiveRecord::Acts::MuckAccessCodeRequest::InstanceMethods
          extend ActiveRecord::Acts::MuckAccessCodeRequest::SingletonMethods
          
        end
      end

      module SingletonMethods
        
        def get_requests(limit = nil)
          if limit && limit.to_i > 0
            self.by_oldest.unfullfilled.all(:limit => limit)
          else
            self.by_oldest.unfullfilled
          end
        end
        
        def mark_fullfilled(access_code_requests)
          access_code_requests.each do |request|
            request.update_attribute(:code_sent_at, DateTime.now)
          end
        end
        
      end
      
      module InstanceMethods
       
      end

    end
  end
end