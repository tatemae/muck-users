require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::ActivationsController do

  before(:each) do
    activate_authlogic
  end
  
  describe "not logged in" do
    before(:each) do
      @password = 'testpass'
      @login = 'testuser'
      @user = Factory(:user, :login => @login, :password => @password, 
                             :password_confirmation => @password, :activated_at => nil)
    end
    describe "activate user" do
      before(:each) do
        get :new, :id => @user.perishable_token
      end
      it {should set_the_flash.to(/Your account has been activated! You can now login/i)}
      it {should redirect_to(welcome_user_path(@user))}
      it "should be able to login" do
        user_session = UserSession.new(:login => @login, :password => @password)
        user_session.save.should be_true
      end
    end
    describe "attempt to activate already activated user" do
      before(:each) do
        @user.activate!
        get :new, :id => @user.perishable_token
      end
      it {should set_the_flash.to(/Your account has already been activated. You can log in below/i)}
      it {should redirect_to(login_path)}
    end    
    describe "don't activate user without key" do
      before(:each) do
        get :new
      end
      it {should set_the_flash.to(/Activation code not found. Please try creating a new account/i)}
      it {should redirect_to(new_user_path)}
    end  
    describe "don't activate user with blank key" do
      before(:each) do
        get :new, :id => ''
      end
      it {should set_the_flash.to(/Activation code not found. Please try creating a new account/i)}
      it {should redirect_to(new_user_path)}
    end
    describe "don't activate user with bad key" do
      before(:each) do
        get :new, :id => 'asdfasdfasdf'
      end
      it {should set_the_flash.to(/Activation code not found. Please try creating a new account/i)}
      it {should redirect_to(new_user_path)}
    end
  end

  describe "logged in" do
    before(:each) do
      @activated_user = Factory(:user)
      login_as @activated_user
      get :new, :id => @activated_user.perishable_token
    end
    it {should redirect_to(@activated_user)}
  end
  
end