require File.expand_path("../../spec_helper", __FILE__)

describe "the signup process", :type => :request do
  before do
    @password = 'asdfasdfa'
    @user = Factory(:user, :password => @password, :password_confirmation => @password)
  end
  
  it "signs me in" do
    visit('/login')
    within("#sign_in_form") do
      fill_in 'user_session_login', :with => @user.login
      fill_in 'user_session_password', :with => @password
    end
    click_button 'Sign In'
  end

  it "fails to sign in because of bad password" do
    visit('/login')
    within("#sign_in_form") do
      fill_in 'user_session_login', :with => 'user@example.com'
      fill_in 'user_session_password', :with => 'password'
    end
    click_button 'Sign In'
  end
  
end