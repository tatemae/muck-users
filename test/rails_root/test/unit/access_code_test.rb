# == Schema Information
#
# Table name: access_codes
#
#  id         :integer(4)      not null, primary key
#  code       :string(255)
#  uses       :integer(4)      default(0), not null
#  unlimited  :boolean(1)      not null
#  expires_at :datetime
#  use_limit  :integer(4)      default(1), not null
#  created_at :datetime
#  updated_at :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class AccessCodeTest < ActiveSupport::TestCase

  context "access code instance" do

    setup do
      Factory(:access_code)
    end
    
    should_validate_presence_of :code, :uses
    should_validate_uniqueness_of :code
    should_have_many :users

    context "named scopes" do
      should_scope_by_newest
      should_scope_by_alpha    
      should "get active codes" do
        codes = [
          Factory(:access_code, :code => 'expired', :expires_at => DateTime.now - 1.day),
          Factory(:access_code, :code => 'overused', :uses => 10, :use_limit => 9, :expires_at => DateTime.now + 2.days),
          Factory(:access_code, :code => 'valid_code', :expires_at => DateTime.now + 5.days), 
        ]
        AccessCode.active.each do |access_code|
          assert_equal 'valid_code', access_code.code
        end
      end
    end
    
    should "use code" do
      access_code = Factory(:access_code)
      access_code.use_code
      access_code.reload
      assert access_code.uses == 1, "access code use was not 1"
    end
    should "not be overused" do
      access_code = Factory(:access_code, :use_limit => 100)
      assert access_code.overused? == false, "access code was not overused"
    end
    should "be over used" do
      access_code = Factory(:access_code, :use_limit => 1)
      access_code.use_code
      access_code.use_code
      assert access_code.overused? == true, "access code was not overused but should have been"
    end
    should "unlimited" do
      access_code = Factory(:access_code, :use_limit => 1, :unlimited => true)
      access_code.use_code
      access_code.use_code
      assert access_code.overused? == false, "access code should be unlimited"
    end
    should "be valid" do
      code = 'accesscodetest'
      access_code = Factory(:access_code, :code => code)
      assert AccessCode.valid_code?(code), "access code was not valid"
    end
    should "be expired" do
      access_code = Factory(:access_code, :unlimited => false, :expires_at => Time.now.to_date - 1.day)
      assert access_code.expired?
    end
    
    should "generate a unique code" do
      AccessCode.random_code.length.should > 0
    end
    
  end
  
end
