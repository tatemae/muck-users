require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::UsersController do

  render_views
  
  it { should require_login :welcome, :get }
  it { should require_login :edit, :get }
  
  describe "configuration tests" do
    teardown do
      MuckUsers.configuration.automatically_activate = false
      MuckUsers.configuration.automatically_login_after_account_create = false
    end
    
    describe "automatically activate account and log user in. " do
      before(:each) do
        MuckUsers.configuration.automatically_activate = true
        MuckUsers.configuration.automatically_login_after_account_create = true
      end
      describe "on POST to :create" do
        describe "html" do
          before(:each) do
            post_create_user
          end
          it { should redirect_to(signup_complete_path(assigns(:user))) }
          it "should activate user" do
            assigns(:user).active?.should be_true
          end
          it "should be logged in" do
            user_session = UserSession.find
            user_session.should_not be_nil
          end
        end
        describe "json" do
          before(:each) do
            post_create_user_json
          end
          it "should return json" do
            user = JSON.parse(@response.body)
            user['success'].should be_true
            user['user']['login'].should == "testguy"
          end
          it "should activate user" do
            assigns(:user).active?.should be_true
          end
          it "should be logged in" do
            user_session = UserSession.find
            user_session.should_not be_nil
          end
        end
        describe "xml" do
          before(:each) do
            post_create_user_xml
          end
          it "should activate user" do
            assert assigns(:user).active? == true, "user was not activated"
          end
          it "should be logged in" do
            user_session = UserSession.find
            user_session.should_not be_nil
          end
        end        
      end
      describe "on POST to :create with bad login (space in login name)" do
        before(:each) do
          post_create_user(:login => 'test guy')
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the login field" do
          assigns(:user).errors[:login].should_not be_empty
        end
      end
    end
  
    describe "automatically activate account do not log user in" do
      before(:each) do
        MuckUsers.configuration.automatically_activate = true
        MuckUsers.configuration.automatically_login_after_account_create = false
      end
      describe "on POST to :create" do  
        before(:each) do
          post_create_user 
        end                             
        it {should redirect_to(signup_complete_login_required_path(assigns(:user))) }
      end    
      describe "on POST to :create with bad login (space in login name)" do
        before(:each) do
          post_create_user(:login => 'test guy')
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the login field" do
          assigns(:user).errors[:login].should_not be_empty
        end
      end   
    end
  
    describe "do not auto activate. do not login after create" do
      before(:each) do
        MuckUsers.configuration.automatically_activate = false
        MuckUsers.configuration.automatically_login_after_account_create = false
      end
      describe "on POST to :create -- Allow signup. " do
        before(:each) do
          post_create_user
        end                                
        it {should redirect_to(signup_complete_activation_required_path(assigns(:user)))}
      end
      describe "on POST to :create -- require login on signup. " do
        before(:each) do
          post_create_user :login => ''
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the login field" do
          assigns(:user).errors[:login].should_not be_empty
        end                                       
      end
      describe "on POST to :create with bad login (space in login name)" do
        before(:each) do
          post_create_user(:login => 'test guy')
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the login field" do
          assigns(:user).errors[:login].should_not be_empty
        end
      end
      describe "on POST to :create -- require password on signup. " do
        before(:each) do 
          post_create_user(:password => nil)
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the password field" do
          assigns(:user).errors[:password].should_not be_empty
        end                                       
      end
      describe "on POST to :create -- require password confirmation on signup. " do
        before(:each) do
          post_create_user(:password_confirmation => nil)
        end
        it { should respond_with :success }
        it { should render_template :new }
          
        it "should assign an error to the password confirmation field" do
          assigns(:user).errors[:password_confirmation].should_not be_empty
        end                                       
      end
      describe "on POST to :create -- require email on signup. " do
        before(:each) do
          post_create_user(:email => nil)
        end
        it { should respond_with :success }
        it { should render_template :new }
        it "should assign an error to the email field" do
          assigns(:user).errors[:email].should_not be_empty 
        end                                       
      end
    end
  end
  
  describe "logged in" do
    before(:each) do
      activate_authlogic
      @user = Factory(:user)
      login_as @user
    end
    
    describe "on GET to :welcome" do
      before(:each) do
        get :welcome, :id => @user.to_param
      end
      it { should respond_with :success }
      it { should render_template :welcome }
    end

    describe "on GET to new (signup) while logged in" do
      before(:each) do
        get :new
      end
      it {should redirect_to(user_url(@user))}
    end

    describe "on GET to show" do
      before(:each) do
        get :show
      end
      it { should respond_with :success }
      it { should render_template :show }
    end
    
    describe "on GET to edit" do
      before(:each) do
        get :edit, :id => @user.to_param
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
    
    describe "on GET to edit logged in but wrong user" do
      before(:each) do
        @other_user = Factory(:user)
        get :edit, :id => @other_user.to_param
      end
      it { should respond_with :success }
      it "should set the user to the logged in user" do
        assert_equal assigns(:user), @user
      end
    end
    
    describe "on PUT to :update" do
      before(:each) do
        put_update_user(@user)
      end
      it {should redirect_to(user_path(@user))}
    end
    
  end
  
  describe "not logged in" do
    before(:each) do
      assure_logout
    end
    describe "on GET to :welcome" do
      before(:each) do
        @user = Factory(:user)
        get :welcome, :id => @user.to_param
      end
      it {should redirect_to(login_path)}
    end
    describe "on GET to :activation_instructions" do
      before(:each) do
        @user = Factory(:user)
        get :activation_instructions, :id => @user.to_param
      end
      it { should respond_with :success }
      it { should render_template :activation_instructions }
    end
    describe "on GET to new (signup)" do
      before(:each) do
        get :new
      end
      it { should respond_with :success }
      it { should render_template :new }
    end
    describe "on GET to show" do
      before(:each) do
        @user = Factory(:user)
        get :show
      end
      it {should redirect_to(login_path)}
    end
    describe "on GET to edit" do
      before(:each) do
        @user = Factory(:user)
        get :edit, :id => @user.to_param
      end
      it {should redirect_to(login_path)}
    end
    describe "on PUT to :update" do
      before(:each) do
        @user = Factory(:user)
        put_update_user(@user)
      end
      it {should redirect_to(login_path)}
    end
  end
  
  describe "GET to login_search" do
    before(:each) do
      @auser = Factory(:user, :login => 'aaaa')
      @zuser = Factory(:user, :login => 'zzzz')
    end
    describe "valid params" do
      before(:each) do
        get :login_search, :q => 'a', :format => 'js'
      end
      it { should respond_with :success }
      it "should find a user" do
        @response.body.should include('aaaa')
        assigns(:users).should include(@auser)
      end
      it "should not find a non-matching user" do
        @response.body.should_not include('zzzz')
      end
    end
    describe "empty params" do
      before(:each) do
        get :login_search, :q => nil, :format => 'js'
      end
      it { should respond_with :success }
      it "should return all users" do
        assigns(:users).should_not be_blank
      end
    end
  end
  
  describe "POST to is_login_available" do
    describe "no params" do
      before(:each) do
        post :is_login_available
      end
      it { should respond_with :success }
      it { @response.body.should == '<span class="unavailable"></span>' }
    end
    describe "empty login" do
      before(:each) do
        post :is_login_available, :user_login => ''
      end
      it { should respond_with :success }
      it { @response.body.should == '<span class="unavailable">' + I18n.t('muck.users.login_empty') + '</span>' }
    end
    describe "valid login" do
      before(:each) do
        post :is_login_available, :user_login => 'testdude1945'
      end
      it { should respond_with :success }
      it { @response.body.should == '<span class="available">' + I18n.t('muck.users.username_available') + '</span>' }
    end
    describe "invalid login" do
      before(:each) do
        post :is_login_available, :user_login => 'testdude1945@example.comm'
      end
      it { should respond_with :success }
      it { response.body.should include(I18n.t('muck.users.invalid_username')) }
    end
    describe "login not available" do
      before(:each) do
        @user = Factory(:user)
        post :is_login_available, :user_login => @user.login
      end
      it { should respond_with :success }
      it { response.body.should include(I18n.t('muck.users.username_not_available')) }
    end
  end
  
  describe "POST to is_email_available" do
    describe "no params" do
      before(:each) do
        post :is_email_available
      end
      it { should respond_with :success }
      it { response.body.should == '<span class="available"></span>' }
    end
    describe "empty email" do
      before(:each) do
        post :is_email_available, :user_email => ''
      end
      it { should respond_with :success }
      it { response.body.should == '<span class="available">' + I18n.t('muck.users.email_empty') + '</span>' }
    end
    describe "valid email" do
      before(:each) do
        post :is_email_available, :user_email => 'testdude1945@example.com'
      end
      it { should respond_with :success }
      it { response.body.should == '<span class="available">' + I18n.t('muck.users.email_available') + '</span>' }
    end
    describe "invalid email" do
      before(:each) do
        post :is_email_available, :user_email => 'testdude1945@com'
      end
      it { should respond_with :success }
      it { response.body.should == '<span class="unavailable">' + I18n.t('muck.users.email_invalid') + '</span>' }
    end
    describe "email not available" do
      before(:each) do
        @user = Factory(:user)
        post :is_email_available, :user_email => @user.email
      end
      it { should respond_with :success }
      it "should indicate the email is not available" do
        response.body.should include(I18n.t('muck.users.email_not_available', :reset_password_help => ''))
      end
    end
  end
  
  def put_update_user(user, options = {})
    put :update,
      :id => user.id, 
      :user => user_params(options)
  end

  def post_create_user(options = {})
    post :create, 
      :user => user_params(options)
  end

  def post_create_user_json(options = {})
    post :create, 
      :user => user_params(options),
      :format => 'json'
  end
  
  def post_create_user_xml(options = {})
    post :create, 
      :user => user_params(options),
      :format => 'xml'
  end
  
  def user_params(options = {})
    { :login => 'testguy', 
      :email => rand(1000).to_s + 'testguy@example.com', 
      :password => 'testpasswrod', 
      :password_confirmation => 'testpasswrod', 
      :first_name => 'Ed',
      :last_name => 'Decker',
      :terms_of_service => true }.merge(options)
  end
  
end
