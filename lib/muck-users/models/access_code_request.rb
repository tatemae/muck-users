# include MuckUsers::Models::MuckAccessCodeRequest
module MuckUsers
  module Models
    module MuckAccessCodeRequest
      extend ActiveSupport::Concern
    
      included do
        validates_presence_of :email
        
        scope :unfullfilled, where('access_code_requests.code_sent_at IS NULL')
        scope :fullfilled, where('access_code_requests.code_sent_at IS NOT NULL')
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
          access_code_requests.each do |r|
            r.update_attribute(:code_sent_at, DateTime.now)
          end
        end
        
      end

      def send_access_code(subject, message, expires_at)
        access_code = AccessCode.create!(:unlimited => false,
                                         :use_limit => 1,
                                         :uses => 0,
                                         :code => AccessCode.random_code,
                                         :expires_at => expires_at,
                                         :sent_to => self.email)
        UserMailer.access_code(self.email, subject, message, access_code.code).deliver
        success = AccessCodeRequest.mark_fullfilled([self])
      end
      
    end
  end
end