# include MuckUsers::Models::MuckAccessCodeRequest
module MuckUsers
  module Models
    module MuckAccessCodeRequest
      extend ActiveSupport::Concern
    
      included do
        validates_presence_of :email
        validates_uniqueness_of :email
        
        scope :unfullfilled, where('access_code_requests.code_sent_at IS NULL')
        scope :by_newest, order("created_at DESC")
        scope :by_oldest, order("created_at ASC")
      end

      module ClassMethods
        
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

    end
  end
end