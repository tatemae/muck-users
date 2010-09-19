$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'muck_test_helper'
require 'rails/test_help'
require 'authlogic/test_case'

class ActiveSupport::TestCase
  include MuckTestMethods
  include Authlogic::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end