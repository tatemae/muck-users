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

require File.dirname(__FILE__) + '/../spec_helper'

describe AccessCode do

  before(:each) do
    @access_code = Factory(:access_code)
  end
      
  it { should validate_presence_of :uses }
  it { should validate_uniqueness_of :code }
  
  it { should have_many :users }
  it { should belong_to :provided_by }

  describe "scopes" do
    
    it { should scope_by_newest }
    
    describe "by_alpha" do
      before(:each) do
        AccessCode.delete_all
        @first = Factory(:access_code, :code => 'a')
        @second = Factory(:access_code, :code => 'b')
      end
      it "should sort by code" do
        @first.should == AccessCode.by_alpha[0]
        @second.should == AccessCode.by_alpha[1]
      end
    end
        
    describe "active" do
      before(:each) do
        AccessCode.delete_all
        codes = [
          Factory(:access_code, :code => 'expired', :expires_at => DateTime.now - 1.day),
          Factory(:access_code, :code => 'overused', :uses => 10, :use_limit => 9, :expires_at => DateTime.now + 2.days),
          Factory(:access_code, :code => 'valid_code', :expires_at => DateTime.now + 5.days), 
        ]
      end
      it "should get active codes" do
        AccessCode.active.each do |access_code|
          access_code.code.should == 'valid_code'
        end
      end
    end
    
  end
  
  it "should use code" do
    access_code = Factory(:access_code)
    access_code.use_code
    access_code.reload
    access_code.uses.should == 1
  end
  it "should not be overused" do
    access_code = Factory(:access_code, :use_limit => 100)
    access_code.should_not be_overused
  end
  it "should be over used" do
    access_code = Factory(:access_code, :use_limit => 1)
    access_code.use_code
    access_code.use_code
    access_code.should be_overused
  end
  it "should unlimited" do
    access_code = Factory(:access_code, :use_limit => 1, :unlimited => true)
    access_code.use_code
    access_code.use_code
    access_code.should_not be_overused
  end
  it "should be valid" do
    code = 'accesscodetest'
    access_code = Factory(:access_code, :code => code)
    AccessCode.valid_code?(code).should be_true
  end
  it "should be expired" do
    access_code = Factory(:access_code, :unlimited => false, :expires_at => Time.now.to_date - 1.day)
    access_code.should be_expired
  end
  
  it "should generate a unique code" do
    AccessCode.random_code.length.should > 0
  end
  
  describe "send_requests" do
    before do
      @access_code = Factory(:access_code)
    end
    it "should return false if set to '0'" do
      @access_code.send_requests = '0'
      @access_code.send_requests.should be_false
    end
    it "should return false if set to 'false'" do
      @access_code.send_requests = 'false'
      @access_code.send_requests.should be_false
    end
    it "should return true if set to true" do
      @access_code.send_requests = true
      @access_code.send_requests.should be_true      
    end
  end
  
end