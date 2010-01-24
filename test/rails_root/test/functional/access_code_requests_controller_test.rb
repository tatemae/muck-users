require File.dirname(__FILE__) + '/../test_helper'

class Muck::AccessCodeRequestsController < ActionController::TestCase

  tests Muck::AccessCodeRequestsController

  context "access code requests controller" do

    context "GET show" do
      setup do
        get :show
      end
      should_respond_with :success
      should_render_template :show
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
        post :create, :access_code_request => {:email => Factory.next(:email)}
      end
      should_redirect_to("show access request") { access_code_request_path(assigns(:access_code)) }
    end

  end
end