require File.dirname(__FILE__) + '/../../test_helper'

class Admin::Muck::AccessCodesControllerTest < ActionController::TestCase

  tests Admin::Muck::AccessCodesController

  should_require_login :index => :get, :bulk => :get, :show => :get, 
                        :new => :get, :create => :post, 
                        :edit => :get, :update => :post, 
                        :destroy => :delete,
                        :login_url => '/login'

  context "access codes controller" do
    setup do
      @access_code = Factory(:access_code)
    end
    
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
        should_render_template 'admin/access_codes/bulk'
      end

      context "bulk create" do
        setup do
          @params = { :emails => 'test@example.com', 
                      :subject => 'test subject', 
                      :message => 'test message',
                      :code => 'testcode', 
                      :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }
        end
        
        context "valid" do
          setup do
            post :bulk_create, :access_code => @params
          end
          should_set_the_flash_to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))
          should_redirect_to("bulk access code page") { bulk_admin_access_codes_path }
        end

        context "valid - sent invites" do
          setup do
            AccessCodeRequest.destroy_all
            Factory(:access_code_request)
            post :bulk_create, :access_code => @params.merge(:send_requests => true)
          end
          should_set_the_flash_to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))
          should_redirect_to("bulk access code page") { bulk_admin_access_codes_path }
          should "set all access codes as fullfilled" do
            assert_equal 0, AccessCodeRequest.unfullfilled.length
          end
        end
        
        context "valid - no access code provided" do
          setup do
            post :bulk_create, :access_code => @params.merge(:code => nil)
          end
          should_set_the_flash_to(I18n.translate('muck.users.bulk_access_codes_created', :email_count => 1))
          should_redirect_to("bulk access code page") { bulk_admin_access_codes_path }
          should "set a random code" do
            assert !assigns(:access_code).code.blank?
          end
        end

        context "no emails provided" do
          setup do
            post :bulk_create, :access_code => @params.merge(:emails => '')
          end
          should_not_set_the_flash
          should_respond_with :success
          should_render_template "admin/access_codes/bulk"
          should "set errors on access_code" do
            assert assigns(:access_code).errors.on(:emails)
          end
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
          post :create, :access_code => { :code => 'testcode', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        should_respond_with :success
        should_render_template :ajax_create_access_code
      end

      context "fail on POST to create" do
        setup do
          post :create, :access_code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        should_respond_with :success
        should "have errors on access code's 'code' field" do
          assert assigns(:access_code).errors.on(:code)
        end
      end
      
      context "GET edit" do
        setup do
          get :edit, :id => @access_code.to_param
        end
        should_respond_with :success
        should_render_template :edit
      end
  
      context "PUT to update" do
        setup do
          put :update, :id => @access_code.to_param, :access_code => {:code => 'testcodetoo', :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        should_respond_with :success
        should "not have errors" do
          assert assigns(:access_code).errors.empty?
        end
      end
  
      context "fail on PUT to update" do
        setup do
          put :update, :id => @access_code.to_param, :access_code => {:code => nil, :expires_at => Date.new((DateTime.now.year + 2), 10, 10) }, :format => 'js'
        end
        should_respond_with :success
        should "have errors on access code's 'code' field" do
          assert assigns(:access_code).errors.on(:code)
        end
      end
  
      context "DELETE to destroy" do
        setup do
          delete :destroy, :id => @access_code.id, :format => 'js'
        end
        should_respond_with :success
        should "destroy the access code provided" do
          after_code = AccessCode.find(@access_code.id) rescue nil
          assert_equal nil, after_code
        end
      end

    end
  
  end
  
end