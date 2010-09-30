require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::UserSessionsController do

  it {should filter_params :password}
  
  before(:each) do
    @login = 'quentin'
    @good_password = 'test'
    @user = Factory(:user, :login => @login, :password => @good_password, :password_confirmation => @good_password)
  end
  describe "get new" do
    before(:each) do
      get :new
    end
    it { should respond_with :success }
    it { should render_template :new }
  end
  describe "login and redirect" do
    before(:each) do
      post :create, :user_session => { :login => @login, :password => @good_password }
    end
    it "should create a user session" do
      assert user_session = UserSession.find
      assert_equal @user, user_session.user        
    end
    it {should redirect_to(user_path(@user))}
  end
  describe "fail login" do
    before(:each) do
      post :create, :user_session => { :login => @login, :password => 'bad password' }
    end
    it "should not create a user session" do
      assert_nil UserSession.find
    end
    it { should respond_with :success }
    it { should render_template :new }
  end

  describe "authlogic enabled" do
    before(:each) do
      @user = Factory(:user)
      activate_authlogic
    end
    describe "logout" do
      before(:each) do
        login_as(@user)
        delete :destroy
      end
      it "should logout by destroying the user session" do
        assert_nil UserSession.find
      end
      it {should redirect_to(logout_complete_path)}
    end
  end
  
end