require File.dirname(__FILE__) + '/../spec_helper'

class AccessCodeRequestTest < ActiveSupport::TestCase

  describe "access code request instance" do

    before(:each) do
      @access_code_request = Factory(:access_code_request)
    end
    
    subject { @access_code_request }
    
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    describe "named scopes" do
      it {should scope_by_newest}
      it {should scope_by_oldest}
      
      describe "unfullfilled" do
        #scope :unfilled, where('access_code_requests.code_sent_at IS NULL')
        before(:each) do
          AccessCodeRequest.delete_all
          @fullfilled = Factory(:access_code_request, :code_sent_at => DateTime.now)
          @unfullfilled = Factory(:access_code_request)
        end
        it "should sort by code" do
          assert !AccessCodeRequest.unfullfilled.include?(@fullfilled)
          assert AccessCodeRequest.unfullfilled.include?(@unfullfilled)
        end
      end
      
    end
    
    describe "get emails" do
      before(:each) do
        # setup a few access codes
        Factory(:access_code_request)
        Factory(:access_code_request)
        Factory(:access_code_request)
      end
      it "should get 1 access code request" do
        access_code_requests = AccessCodeRequest.get_requests(1)
        assert_equal 1, access_code_requests.length
      end
      it "should get all access code requests" do
        access_code_requests = AccessCodeRequest.get_requests('')
        assert access_code_requests.length > 0
      end
    end
    
    describe "mark_fullfilled" do
      AccessCodeRequest.mark_fullfilled(AccessCodeRequest.get_requests)
    end
    
  end
  
end