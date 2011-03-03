module MuckUsers
  module Exceptions
    class InvalidPasswordResetCode < StandardError; end
    class InvalidAccessCode < StandardError; end
  end
end