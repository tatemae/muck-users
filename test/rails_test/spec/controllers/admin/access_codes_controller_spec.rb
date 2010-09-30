require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::AccessCodesController do

  it { should require_login :index, :get }
  it { should require_login :bulk, :get }
  it { should require_login :show, :get }
  it { should require_login :new, :get }
  it { should require_login :create, :post }
  it { should require_login :edit, :get }
  it { should require_login :update, :post }
  it { should require_login :destroy, :delete }

  describe "access codes controller" do
    before(:each) do
      @access_code = Factory(:access_code)
    end
    
    describe "logged in not admin" do
      before(:each) do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      it { should require_role('admin', :index, :get ) }
      it { should require_role('admin', :bulk, :get ) }
      it { should require_role('admin', :bulk_create, :post ) }
      it { should require_role('admin', :new, :get ) }
      it { should require_role('admin', :create, :post ) }
      it { should require_role('admin', :edit, :get ) }
      it { should require_role('admin', :update, :put ) }
      it { should require_role('admin', :destroy, :delete ) }
    end

    describe "logged in as admin" do
      before(:each) do
        @admin = Factory(:user)
        @admin_role = Factory(:role, :rolename => 'administrator')
        @admin.roles << @admin_role
        activate_authlogic
        login_as @admin
      end

      describe "GET index" do
        before(:each) do
          get :index
        end
        it { should respond_with :success }
        it { should render_template :index }
      end

      describe "GET bulk" do
        before(:each) do
          get :bulk
        end
        it { should respond_with :success }
        it { should render_template 'admin/access_codes/bulk' }
      end

      describe "bulk create" do
        before(:each) do
          @params = { :emails => 'test@example.com', 
                      :subject => 'test subject', 
                      :message => 'test message',
                      :code => 'testcode', 
                      :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        
        describe "valid" do
          before(:each) do
            post :bulk_create, :access_code => @params
          end
          it {should set_the_flash.to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))}
          it {should redirect_to(bulk_admin_access_codes_path)}
        end

        describe "valid - sent invites" do
          before(:each) do
            AccessCodeRequest.destroy_all
            Factory(:access_code_request)
            post :bulk_create, :access_code => @params.merge(:send_requests => true)
          end
          it {should set_the_flash.to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))}
          it {should redirect_to(bulk_admin_access_codes_path)}
          it "should set all access codes as fullfilled" do
            AccessCodeRequest.unfullfilled.length.should == 0
          end
        end
        
        describe "valid - no access code provided" do
          before(:each) do
            post :bulk_create, :access_code => @params.merge(:code => nil)
          end
          it {should set_the_flash.to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))}
          it {should redirect_to(bulk_admin_access_codes_path)}
          it "should set a random code" do
            assigns(:access_code).code.should_not be_nil
          end
        end

        describe "no emails provided" do
          before(:each) do
            post :bulk_create, :access_code => @params.merge(:emails => '')
          end
          it {should not_set_the_flash}
          it { should respond_with :success }
          it { should render_template "admin/access_codes/bulk" }
          it "should set errors on access_code" do
            assigns(:access_code).errors[:emails].should_not be_empty
          end
        end

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
          post :create, :access_code => { :code => 'testcode', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        it { should respond_with :success }
        it { should render_template :ajax_create_access_code }
      end

      describe "fail on POST to create" do
        before(:each) do
          post :create, :access_code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        it { should respond_with :success }
        it "should have errors on access code's 'code' field" do
          assigns(:access_code).errors[:code].should_not be_empty
        end
      end
      
      describe "GET edit" do
        before(:each) do
          get :edit, :id => @access_code.to_param
        end
        it { should respond_with :success }
        it { should render_template :edit }
      end
  
      describe "PUT to update" do
        before(:each) do
          put :update, :id => @access_code.to_param, :access_code => {:code => 'testcodetoo', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        it { should respond_with :success }
        it "should not have errors" do
          assigns(:access_code).errors.should be_nil
        end
      end
  
      describe "fail on PUT to update" do
        before(:each) do
          put :update, :id => @access_code.to_param, :access_code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        it { should respond_with :success }
        it "should have errors on access code's 'code' field" do
          assigns(:access_code).errors[:code].should_not be_empty
        end
      end
  
      describe "DELETE to destroy" do
        before(:each) do
          delete :destroy, :id => @access_code.id, :format => 'js'
        end
        it { should respond_with :success }
        it "should destroy the access code provided" do
          after_code = AccessCode.find(@access_code.id) rescue nil
          after_code.should be_nil
        end
      end

    end
  
  end
  
end