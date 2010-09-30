require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::AccessCodeRequestsController do

  describe "GET show" do
    before(:each) do
      get :show
    end
    it { should respond_with :success }
    it { should render_template :show }
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
      post :create, :access_code_request => { :email => Factory.next(:email) }
    end
    it { should redirect_to(access_code_request_path(assigns(:access_code_request))) }
  end

end