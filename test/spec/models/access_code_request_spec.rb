require File.dirname(__FILE__) + '/../spec_helper'

describe AccessCodeRequest do

  before(:each) do
    @access_code_request = Factory(:access_code_request)
  end
  
  
  
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
    it "should mark the request fullfilled" do
      AccessCodeRequest.mark_fullfilled(AccessCodeRequest.get_requests)
      @access_code_request.reload
      @access_code_request.code_sent_at.should_not be_blank
    end
  end
  
  describe "send_access_code" do
    before do
      @access_code_request = Factory(:access_code_request)
      @subject = "test subject"
      @message = "test message"
      @expires_at = 1.year.from_now
    end
    it "should create an access code" do
      lambda {
        @access_code_request.send_access_code(@subject, @message, @expires_at)
      }.should change(AccessCode, :count)
    end
    it "should send the user an email with the access code" do
      mailer = mock(:user_mailer)
      mailer.should_receive(:deliver)
      UserMailer.should_receive(:access_code).and_return(mailer)
      @access_code_request.send_access_code(@subject, @message, @expires_at)
    end
    it "should mark the request fullfilled" do
      AccessCodeRequest.should_receive(:mark_fullfilled)
      @access_code_request.send_access_code(@subject, @message, @expires_at)
    end
  end

end