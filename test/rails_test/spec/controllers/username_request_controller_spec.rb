require File.dirname(__FILE__) + '/../spec_helper'

class Muck::UsernameRequestControllerTest < ActionController::TestCase

  tests Muck::UsernameRequestController

  describe "username request controller" do
    before(:each) do
      @user = Factory(:user)
    end
    describe "get new" do
      before(:each) do
        get :new
      end
      it { should respond_with :success }
      it { should render_template :new }
    end
    describe "find user using email and send email message" do
      before(:each) do
        post :create, :request_username => { :email => @user.email }
      end
      it "should send username" do
        assert_sent_email do |email|
          email.to.include?(@user.email)
        end
      end
      it {should redirect_to(login_path)}
    end
    describe "bad email - fail to send username" do
      before(:each) do
        post :create, :request_username => { :email => 'quentin@bad_email_example.com' }
      end
      it { should respond_with :success }
      it { should render_template :new }
    end

  end

end
