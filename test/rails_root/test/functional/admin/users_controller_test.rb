require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::UsersControllerTest < ActionController::TestCase

  tests Admin::Muck::UsersController

  should_require_login :index => :get, :inactive => :get, :inactive_emails => :get, :activate_all => :get, :search => :get, :login_url => '/login'

  context "logged in not admin" do
    setup do
      @user = Factory(:user)
      activate_authlogic
      login_as @user
    end
    should_require_role('admin', :redirect_url => '/login', :index => :get)
  end
  
  context "logged in as admin" do
    setup do
      @user = Factory(:user)
      @admin = Factory(:user)
      @admin_role = Factory(:role, :rolename => 'administrator')
      @admin.roles << @admin_role
      activate_authlogic
      login_as @admin
    end
    
    context "GET index" do
      context "html" do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template :index
      end
      context "csv" do
        setup do
          get :index, :format => 'csv'
        end
        should_respond_with :success
        should_render_template :index
      end
    end

    context "GET inactive" do
      setup do
        get :inactive
      end
      should_respond_with :success
      should_render_template :inactive
    end
    
    context "GET search" do
      setup do
        get :search
      end
      should_respond_with :success
      should_render_template :index
    end

    context "GET ajax search" do
      setup do
        get :ajax_search
      end
      should_respond_with :success
      should_render_template :table
    end

    context "GET edit" do
      setup do
        get :edit, :id => @user.to_param
      end
      should_respond_with :success
      should_render_template :edit
    end
    
    context "PUT to update" do
      setup do
        put :update, :id => @user.to_param, :user => { :email => 'testguy@example.com' }, :format => 'js'
      end
      should_respond_with :success
      should "not have errors" do
        assert assigns(:user).errors.empty?
      end
    end

    context "fail on PUT to update" do
      setup do
        put :update, :id => @user.to_param, :user => { :email => nil }, :format => 'js'
      end
      should_respond_with :success
      should "have errors on access code's 'email' field" do
        assert assigns(:user).errors.on(:email)
      end
    end
    
    context "PUT to update - deactivate user" do
      setup do
        put :update, :id => @user.to_param, :deactivate => true, :format => 'js'
      end
      should_respond_with :success
      should "deactivate the user" do
        assert !User.find(@user.to_param).active?
      end
    end
    
    context "PUT to update - activate user" do
      setup do
        put :update, :id => @user.to_param, :activate => true, :format => 'js'
      end
      should_respond_with :success
      should "activate the user" do
        assert User.find(@user.to_param).active?
      end
    end
    
    context "PUT to update - update roles" do
      setup do
        @new_role = Factory(:role)
        put :update, :id => @user.to_param, :update_roles => true, :user => { :role_ids => [ @new_role.id ] }, :format => 'js'
      end
      should_respond_with :success
      should "give user the new role" do
        assert User.find(@user.to_param).has_role?(@new_role.rolename)
      end
    end
    
    context "PUT to update - remove all roles" do
      setup do
        put :update, :id => @user.to_param, :update_roles => true, :format => 'js'
      end
      should_respond_with :success
      should "remove the user from all roles" do
        assert User.find(@user.to_param).roles.empty?
      end
    end

    context 'on DELETE to :destroy' do
      setup do
        @user = Factory(:user)
        delete :destroy, {:id => @user.to_param}
      end
      should_redirect_to("Main user screen") { admin_users_path }
    end

  end

end
