module ActiveRecord
  module SecureMethods

    protected

    def check_creator(user)
      check(user, :creator_id)
    end

    def check_user(user)
      check(user, :user_id)
    end

    def check_sharer(user)
      check(user, :shared_by_id)
    end
 
    def check(user, field)
      if user && user != false
        self.send(field) == user.id || user.admin?
      else
        false
      end
    end

  end
end