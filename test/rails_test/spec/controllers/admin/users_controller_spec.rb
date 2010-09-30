require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::UsersController do

  it { should require_login :index, :get }
  it { should require_login :inactive, :get }
  it { should require_login :inactive_emails, :get }
  it { should require_login :activate_all, :post }
  it { should require_login :search, :post }
  
  describe "logged in not admin" do
    before(:each) do
      @user = Factory(:user)
      activate_authlogic
      login_as @user
    end
    it {should require_role('admin', :index, :get)}
  end
  
  describe "logged in as admin" do
    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:user)
      @admin_role = Factory(:role, :rolename => 'administrator')
      @admin.roles << @admin_role
      activate_authlogic
      login_as @admin
    end
    
    describe "GET index" do
      describe "html" do
        before(:each) do
          get :index
        end
        it { should respond_with :success }
        it { should render_template :index }
      end
      describe "csv" do
        before(:each) do
          get :index, :format => 'csv'
        end
        it { should respond_with :success }
        it { should render_template :index }
      end
    end

    describe "GET inactive" do
      before(:each) do
        get :inactive
      end
      it { should respond_with :success }
      it { should render_template :inactive }
    end
    
    describe "search" do
      before(:all) do
        @user = Factory(:user, :first_name => 'john', :last_name => 'smith', :email => 'john.smith@example.com')
      end
      describe 'html' do
        describe 'empty search' do
          before(:each) do
            post :search
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
        describe 'search first name' do
          before(:each) do
            post :search, :query => { :first_name => 'john' }
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
        describe 'search last name' do
          before(:each) do
            post :search, :query => { :last_name => 'smith' }
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
        describe 'search email' do
          before(:each) do
            post :search, :query => { :email => 'john.smith@example.com' }
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
      end
      describe 'js' do
        describe 'empty search' do
          before(:each) do
            post :search, :format => 'js'
          end
          it { should respond_with :success }
          it { should render_template :table }
        end
        describe 'search first name' do
          before(:each) do
            post :search, :query => { :first_name => 'john' }, :format => 'js'
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
        describe 'search last name' do
          before(:each) do
            post :search, :query => { :last_name => 'smith' }, :format => 'js'
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
        describe 'search email' do
          before(:each) do
            post :search, :query => { :email => 'john.smith@example.com' }, :format => 'js'
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { should render_text 'john' }
        end
      end
    end

    # describe "search" do
    #   before(:each) do
    #     @user = Factory(:user, :first_name => 'john', :last_name => 'smith', :email => 'john.smith@example.com') 
    #   end
    #   it "should find john" do
    #     User.where(:first_name => 'john').all.should include(@user)
    #   end
    #   it "should find smith" do
    #     User.where(:last_name => 'smith').all.should include(@user)
    #   end
    #   it "should find john.smith@example.com" do
    #     User.where(:email => 'john.smith@example.com').all.should include(@user)
    #   end
    # end


    describe "GET edit" do
      before(:each) do
        get :edit, :id => @user.to_param
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end
    
    describe "PUT to update" do
      before(:each) do
        put :update, :id => @user.to_param, :user => { :email => 'testguy@example.com' }, :format => 'js'
      end
      it { should respond_with :success }
      it "should not have errors" do
        assigns(:user).errors.should be_nil
      end
    end

    describe "fail on PUT to update" do
      before(:each) do
        put :update, :id => @user.to_param, :user => { :email => nil }, :format => 'js'
      end
      it { should respond_with :success }
      it "should have errors on access code's 'email' field" do
        assigns(:user).errors[:email].should_not be_empty
      end
    end
    
    describe "PUT to update - deactivate user" do
      before(:each) do
        put :update, :id => @user.to_param, :deactivate => true, :format => 'js'
      end
      it { should respond_with :success }
      it "should deactivate the user" do
        User.find(@user.to_param).should_not be_active
      end
    end
    
    describe "PUT to update - activate user" do
      before(:each) do
        put :update, :id => @user.to_param, :activate => true, :format => 'js'
      end
      it { should respond_with :success }
      it "should activate the user" do
        User.find(@user.to_param).should be_active
      end
    end
    
    describe "PUT to update - update roles" do
      before(:each) do
        @new_role = Factory(:role)
        put :update, :id => @user.to_param, :update_roles => true, :user => { :role_ids => [ @new_role.id ] }, :format => 'js'
      end
      it { should respond_with :success }
      it "should give user the new role" do
        User.find(@user.to_param).has_role?(@new_role.rolename).should be_true
      end
    end
    
    describe "PUT to update - remove all roles" do
      before(:each) do
        put :update, :id => @user.to_param, :update_roles => true, :format => 'js'
      end
      it { should respond_with :success }
      it "should remove the user from all roles" do
        User.find(@user.to_param).roles.should be_empty
      end
    end

    describe 'on DELETE to :destroy' do
      before(:each) do
        @user = Factory(:user)
        delete :destroy, {:id => @user.to_param}
      end
      it {should redirect_to(admin_users_path)}
    end

  end

end
