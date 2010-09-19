require File.dirname(__FILE__) + '/../test_helper'

class AccessCodeRequestTest < ActiveSupport::TestCase

  context "access code request instance" do

    setup do
      @access_code_request = Factory(:access_code_request)
    end
    
    subject { @access_code_request }
    
    should_validate_presence_of :email
    should_validate_uniqueness_of :email

    context "named scopes" do
      should_scope_by_newest
      should_scope_by_oldest
      
      context "unfullfilled" do
        #scope :unfilled, where('access_code_requests.code_sent_at IS NULL')
        setup do
          AccessCodeRequest.delete_all
          @fullfilled = Factory(:access_code_request, :code_sent_at => DateTime.now)
          @unfullfilled = Factory(:access_code_request)
        end
        should "sort by code" do
          assert !AccessCodeRequest.unfullfilled.include?(@fullfilled)
          assert AccessCodeRequest.unfullfilled.include?(@unfullfilled)
        end
      end
      
    end
    
    context "get emails" do
      setup do
        # setup a few access codes
        Factory(:access_code_request)
        Factory(:access_code_request)
        Factory(:access_code_request)
      end
      should "get 1 access code request" do
        access_code_requests = AccessCodeRequest.get_requests(1)
        assert_equal 1, access_code_requests.length
      end
      should "get all access code requests" do
        access_code_requests = AccessCodeRequest.get_requests('')
        assert access_code_requests.length > 0
      end
    end
    
    context "mark_fullfilled" do
      AccessCodeRequest.mark_fullfilled(AccessCodeRequest.get_requests)
    end
    
  end
  
end