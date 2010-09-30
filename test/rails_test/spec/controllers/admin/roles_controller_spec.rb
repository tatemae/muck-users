require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::RolesController do

  it { should require_login(:index, :get) }
  it { should require_login(:show, :get) }
  it { should require_login(:new, :get) }
  it { should require_login(:create, :post) }
  it { should require_login(:edit, :get) }
  it { should require_login(:update, :post) }
  it { should require_login(:destroy, :delete) }
  
  describe "logged in not admin" do
    before(:each) do
      @user = Factory(:user)
      activate_authlogic
      login_as @user
    end
    it { should require_role('admin', :index, :get) }
    it { should require_role('admin', :show, :get) }
    it { should require_role('admin', :new, :get) }
    it { should require_role('admin', :create, :post) }
    it { should require_role('admin', :edit, :get) }
    it { should require_role('admin', :update, :put) }
    it { should require_role('admin', :destroy, :delete) }
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
    end
  
    describe "GET show" do
      describe "html" do
        before(:each) do
          @role = Factory(:role)
          get :show, :id => @role.id
        end
        it { should respond_with :success }
        it { should render_template :show }
      end
    end
    
    describe "GET new" do
      describe "html" do
        before(:each) do
          get :new
        end
        it { should respond_with :success }
        it { should render_template :new }
      end
    end
    
    describe "GET edit" do
      describe "html" do
        before(:each) do
          @role = Factory(:role)
          get :edit, :id => @role.id
        end
        it { should respond_with :success }
        it { should render_template :edit }
      end
    end
    
  end
  
end