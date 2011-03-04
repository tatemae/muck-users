require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::AccessCodeRequestsController do

  render_views
  
  describe "GET show" do
    before(:each) do
      get :show
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "GET new" do
    before(:each) do
      get :new
    end
    it { should respond_with :success }
    it { should render_template :new }
  end

  describe "POST to create" do
    before(:each) do
      post :create, :access_code_request => { :email => Factory.next(:email) }
    end
    it { should redirect_to(access_code_request_path(assigns(:access_code_request))) }
  end

  describe "POST to create (js)" do
    before(:each) do
      post :create, :access_code_request => { :email => Factory.next(:email) }, :format => 'js'
    end
    it { should render_template 'access_code_requests/create' }
  end
  
  describe "logged in" do
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end
    describe "POST to create" do
      before(:each) do
        post :create, :access_code_request => { :email => Factory.next(:email) }
      end      
      it { should redirect_to(@user) }
      it { should set_the_flash.to(I18n.translate('muck.users.beta_code_not_required')) }
    end
    describe "POST to create (js)" do
      before(:each) do
        post :create, :access_code_request => { :email => Factory.next(:email) }, :format => 'js'
      end
      it { should render_template 'access_code_requests/create' }
      it "should indicate the user is already logged in" do
        assigns(:indicate_logged_in).should be_true
      end
    end
  end
  
  
end