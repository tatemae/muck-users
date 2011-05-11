require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  it "should send activation confirmation email" do
    user = Factory(:user)
    email = UserMailer.activation_confirmation(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.activation_complete')
    #email.body.should include(user.login)
  end

  it "should send activation instructions email" do
    user = Factory(:user)
    email = UserMailer.activation_instructions(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.activation_instructions')
    #email.body.should include(user.login)
  end

  it "should send password reset account not active instructions email" do
    user = Factory(:user)
    email = UserMailer.password_not_active_instructions(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.account_not_activated', :application_name => MuckEngine.configuration.application_name)
  end
  
  it "should send password reset instructions email" do
    user = Factory(:user)
    email = UserMailer.password_reset_instructions(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.password_reset_email_subject', :application_name => MuckEngine.configuration.application_name)
  end
  
  it "should send username request email" do
    user = Factory(:user)
    email = UserMailer.username_request(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.request_username_subject', :application_name => MuckEngine.configuration.application_name)
  end
  
  it "should send welcome email" do
    user = Factory(:user)
    email = UserMailer.welcome_notification(user).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [user.email]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.welcome_email_subject', :application_name => MuckEngine.configuration.application_name)
  end
  
  describe "access code email" do
    before do
      @email_address = 'testguy@example.com'
      @subject = 'test subject'
      @message = 'test message'
      @code = 'testcode'
    end
    it "should send access code email" do
      email = UserMailer.access_code(@email_address, @subject, @message, @code).deliver
      ActionMailer::Base.deliveries.should_not be_empty
      email.to.should == [@email_address]
      email.from.should == [MuckEngine.configuration.from_email]
      email.subject.should == @subject
      email.body.parts[0].body.should include(@message)
      email.body.parts[0].body.should include(@code)
    end
    it "should set code_included to true" do
      @message = "message that includes {code}"
      email = UserMailer.access_code(@email_address, @subject, @message, @code).deliver
      email.body.parts[0].body.should include(@message.gsub('{code}', @code))
      email.body.parts[0].body.should_not include("<p>Access Code: #{@code}</p>")
    end
    it "should set signup_link_included to true" do
      # HACK the signup link shouldn't be hard coded. It needs to be stubbed somehow - just not sure how.
      signup = '<a href="http://localhost:3000/signup?access_code=testcode">Click here to sign up now.</a>'
      @message = "message that includes {signup_link}"      
      email = UserMailer.access_code(@email_address, @subject, @message, @code).deliver
      email.body.parts[0].body.should include(@message.gsub('{signup_link}', signup))
      email.body.parts[0].body.should_not include("<p>#{signup}</p>")
    end
  end
  
  it "should send access code request confirmation email" do
    email_address = 'testguy@example.com'
    email = UserMailer.access_code_request_confirm(email_address).deliver
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should == [email_address]
    email.from.should == [MuckEngine.configuration.from_email]
    email.subject.should == I18n.t('muck.users.access_code_request_confirm_subject', :application_name => MuckEngine.configuration.application_name)
  end
  
end
