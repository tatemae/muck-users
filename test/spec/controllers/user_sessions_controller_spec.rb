require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::UserSessionsController do

  render_views
  
  it { should filter_param(:password) }
  
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
      @user.should == user_session.user        
    end
    it {should redirect_to(user_path(@user))}
  end
  
  describe "login success and render json" do
    before(:each) do
      post :create, :user_session => { :login => @login, :password => @good_password }, :format => 'json'
    end
    it "should create a user session" do
      assert user_session = UserSession.find
      @user.should == user_session.user        
    end
    it "should render true" do
      @response.body.should include('true')
    end
  end
  
  describe "fail login" do
    before(:each) do
      post :create, :user_session => { :login => @login, :password => 'bad password' }
    end
    it "should not create a user session" do
      UserSession.find.should be_nil
    end
    it { should respond_with :success }
    it { should render_template :new }
  end

  describe "fail login json" do
    before(:each) do
      post :create, :user_session => { :login => @login, :password => 'bad password' }, :format => 'json'
    end
    it "should not create a user session" do
      UserSession.find.should be_nil
    end
    it "should render false" do
      @response.body.should include('false')
    end
  end
  
  describe "authlogic enabled" do
    before(:each) do
      @user = Factory(:user)
      activate_authlogic
    end
    describe "logout" do
      before(:each) do
        login_as(@user)
      end
      describe "without params" do
        before(:each) do
          delete :destroy
        end
        it "should logout by destroying the user session" do
          UserSession.find.should be_nil
        end
        it {should redirect_to(logout_complete_path)}
      end
      describe "with reset api key param" do
        it "should reset the user's single_access_token" do
          @user.should_receive(:reset_single_access_token!)
          delete :destroy, :reset_api_key => true
        end
      end
    end
  end
  
  describe "GET login_check" do
    before do
      @user = Factory(:user)
      activate_authlogic
    end
    describe "logged in" do
      before do
       login_as(@user)
        get :login_check
      end
      it "should render json with logged in true" do
        @response.body.should include('true')
      end
    end
    describe "not logged in" do
      before do
        get :login_check
      end
      it "should render json with logged in false" do
        @response.body.should include('false')
      end
    end
  end
  
end