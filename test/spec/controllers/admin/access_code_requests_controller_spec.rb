require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::AccessCodeRequestsController do
  
  render_views
  
  it { should require_login :index, :get }
 
  describe "access code requests controller" do
    before(:each) do
      @access_code_request = Factory(:access_code_request)
    end
    
    describe "logged in not admin" do
      before(:each) do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      it { should require_role('admin', :index, :get ) }
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
      
      describe "GET send_code" do
        before(:each) do
          get :send_code, :id => @access_code_request.to_param
        end
        it { should respond_with :success }
        it { should render_template :send_code }
      end
      
      describe "GET edit" do
        before(:each) do
          get :edit, :id => @access_code_request.to_param
        end
        it { should respond_with :success }
        it { should render_template :edit }
      end
  
      describe "POST search" do
        before(:all) do
          @user = Factory(:access_code_request, :name => 'john smith', :email => 'john.smith@example.com')
        end
        describe "empty search" do
          before(:each) do
            post :search, :query => ''
          end
          it { should respond_with :success }
          it { should render_template :index }
        end
        describe "search name" do
          before(:each) do
            post :search, :query => 'john'
          end
          it { should respond_with :success }
          it { should render_template :index }
          it { response.body.should include('john') }
        end
        describe "search email" do
          before(:each) do
            post :search, :query => 'john.smith@example.com'
          end
          it { should respond_with :success }
          it { should render_template :index } 
          it { response.body.should include('john') }         
        end
      end
          
      describe "PUT to update" do
        before(:each) do
          put :update, :id => @access_code_request.to_param, :access_code_request => { :email => 'test@example.com' }, :format => 'js'
        end
        it { should respond_with :success }
        it "should not have errors" do
          assigns(:access_code_request).errors.should be_empty
        end
      end
  
      describe "PUT to update - send access code" do
        it "should send an access code" do
          AccessCodeRequest.stub!(:find).and_return(@access_code_request)          
          @access_code_request.should_receive(:send_access_code)
          put :update, :id => @access_code_request.to_param, :send_access_code => true, :format => 'js'
        end
      end
          
      describe "fail on PUT to update" do
        before(:each) do
          put :update, :id => @access_code_request.to_param, :access_code_request => { :email => nil }, :format => 'js'
        end
        it { should respond_with :success }
        it "should have errors on access code's 'code' field" do
          assigns(:access_code_request).errors[:email].should_not be_empty
        end
      end
      
      describe "DELETE to destroy" do
        before(:each) do
          delete :destroy, :id => @access_code_request.id, :format => 'js'
        end
        it { should respond_with :success }
        it "should destroy the access code request provided" do
          after_code = AccessCodeRequest.find(@access_code_request.id) rescue nil
          after_code.should be_nil
        end
      end
      
    end
    
  end
  
end