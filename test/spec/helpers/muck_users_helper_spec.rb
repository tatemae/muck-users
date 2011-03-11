require File.dirname(__FILE__) + '/../spec_helper'

describe MuckUsersHelper do
  
  before do
    @user = Factory(:user)
  end
  
  describe "signup_form" do
    it "should render the sign up form" do
      title = 'This is a great title for a test sign up form.'
      helper.signup_form(@user, nil, {:title => title}).should include(title)
    end
    
    describe "signup with access codes enabled" do
      before do
        MuckUsers.configuration.stub!(:require_access_code).and_return(true)
      end
      describe "with valid access code" do
        before(:each) do
          @access_code = Factory(:access_code, :sent_to => 'testguy@example.com')
        end
        it "should include an access code from the params" do
          params = {}
          params[:access_code] = @access_code.code
          helper.stub!(:params).and_return(params)
          helper.signup_form(@user).should include('testguy@example.com')
        end
        it "should include an access code from the session" do
          controller.session[:access_code] = @access_code.code
          helper.signup_form(@user).should include('testguy@example.com')
        end
      end
      describe "without valid access code" do
        before(:each) do
          controller.params = {:access_code => 'bogus'}
        end
        it "should not find the access code" do
          helper.signup_form(@user).should include('access-code-not-found-msg')
        end
      end
    end
  end
  
  describe "signin_form" do
    it "should render the sign in form" do
      title = 'This is a great title for a test sign in form.'
      helper.signin_form({:title => title}).should include(title)
    end
  end
  
end