require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::AccessCodesController < ActionController::TestCase

  tests Admin::Muck::AccessCodesController

  should_require_login :index => :get, :bulk => :get, :show => :get, 
                        :new => :get, :create => :post, 
                        :edit => :get, :update => :post, 
                        :destroy => :delete,
                        :login_url => '/login'

  context "access codes controller" do

    context "logged in not admin" do
      setup do
        @user = Factory(:user)
        activate_authlogic
        login_as @user
      end
      should_require_role('admin', :redirect_url => '/login', :index => :get, 
                      :bulk => :get, :bulk_create => :post,
                      :new => :get, :create => :post,
                      :edit => :get, :update => :put,
                      :destroy => :delete)
    end

    context "logged in as admin" do
      setup do
          @admin = Factory(:user)
          @admin_role = Factory(:role, :rolename => 'administrator')
          @admin.roles << @admin_role
          activate_authlogic
          login_as @admin
          
          # Add a couple of access codes
          @one = Factory(:access_code)
          @two = Factory(:access_code)
        end
      end

      context "GET index" do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template :index
      end
      
      context "GET bulk" do
        setup do
          get :bulk
        end
        should_respond_with :success
        should_render_template :bulk
      end

      context "bulk create" do
        setup do
          @code = 'randomcode'
          @emails = 'test@example.com'
          @subject = 'test subject'
          @message = 'test message'
          @params = {:code => 'testcode', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        
        context "POST to bulk_create - valid" do
          setup do
            @code = 'randomcode'
            @emails = 'test@example.com'
            @subject = 'test subject'
            @message = 'test message'
            @params = {:code => 'testcode', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
            post :bulk_create, {:access_code => @params, :emails => @emails, :subject => @subject, :message => @message}
          end
          should_set_the_flash_to(I18n.translate('muck.users.bulk_access_codes_created'))
          should_redirect_to("bulk access code page") { admin_bulk_create_access_codes_path)) }
        end
        
        context "invalid access code" do
          setup do
            post :bulk_create, {:access_code => @params.merge(:code => nil), :emails => @emails, :subject => @subject, :message => @message}
          end
          should_respond_with :success
          should_render_template :bulk
        end
    
      end
  
      context "GET new" do
        setup do
          get :new
        end
        should_respond_with :success
        should_render_template :new
      end

      context "POST to create" do
        setup do
          post :create, :access code => { :code => 'testcode', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        should_redirect_to("show access code") { admin_access_code_path(assigns(:access_code)))) }
      end

      context "fail on POST to create" do
        setup do
          post :create, :access code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        should_respond_with :success
        should_render_template :new
        should "have errors on access code's 'code' field" do
          assert assigns[:access_code].errors.on(:code)
        end
      end
      
      context "GET edit" do
        setup do
          @access_code = Factory(:access_code)
          get :edit, :id => @access_code.to_param
        end
        should_respond_with :success
        should_render_template :new
      end
  
      context "PUT to update" do
        setup do
          put :update, :access_code => {:code => 'testcodetoo', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        should_redirect_to("show access code") { admin_access_code_path(assigns(:access_code)))) }
      end
  
      context "fail on PUT to update" do
        setup do
          put :update, :access_code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        should_respond_with :success
        should_render_template :edit
        should "have errors on access code's 'code' field" do
          assert assigns[:access_code].errors.on(:code)
        end
      end
  
      context "DELETE to destroy" do
        setup do
          @access_code = Factory(:access_code)
          delete :destroy, :id => @access_code.id
        end
        should_redirect_to("show access codes") { admin_access_codes_path)) }
        should "destroy the access code provided" do
          after_code = AccessCode.find(@access_code.id) rescue nil
          assert_equal nil, after_code
        end
      end

    end
  end
end