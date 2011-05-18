require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::PasswordResetsController do

  render_views
  
  describe "password reset controller" do
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
        post :create, :reset_password => { :email => @user.email } 
      end
      it { should set_the_flash.to(I18n.translate('muck.users.password_reset_link_sent')) }    
      it {should redirect_to(login_path)}
    end
    describe "bad email - fail to reset password" do
      before(:each) do
        post :create, :reset_password => { :email => 'quentin@bad_email_example.com' }
      end
      it { should respond_with :success }
      it { should render_template :new }
    end
    describe "inactive user - send password not active instructions" do
      before(:each) do
        @inactive_user = Factory(:user, :activated_at => nil)
        post :create, :reset_password => { :email => @inactive_user.email }
      end      
      it { should set_the_flash.to(I18n.translate('muck.users.password_reset_link_sent')) }    
      it{should redirect_to(login_path)}
    end
    describe "get edit" do
      before(:each) do
        get :edit, :id => @user.perishable_token
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
    describe "PUT update" do
      before(:each) do
        put :update, :id => @user.perishable_token, :user => {:password => "foobar", :password_confirmation => "foobar" }
      end
      it {should redirect_to(login_url)}
    end
    describe "PUT update - password mismatch" do
      before(:each) do
        put :update, :id => @user.perishable_token, :user => {:password => "foobar", :password_confirmation => "foobarbaz"}
      end
      it "should fail to update user password because passwords do not match" do
        assigns(:user).errors[:password].should_not be_empty
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
  end

end
