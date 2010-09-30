require File.dirname(__FILE__) + '/../spec_helper'
require 'user_mailer'

describe UserMailer do

  describe "deliver emails" do

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
      email.body.should include(user.login)
    end

    it "should send activation instructions email" do
      user = Factory(:user)
      email = UserMailer.activation_instructions(user).deliver
      ActionMailer::Base.deliveries.should_not be_empty
      email.to.should == [user.email]
      email.from.should == [MuckEngine.configuration.from_email]
      email.subject.should == I18n.t('muck.users.activation_instructions')
      email.body.should include(user.login)
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
    
    it "should send access code email" do
      email_address = 'testguy@example.com'
      subject = 'test subject'
      message = 'test message'
      code = 'testcode'
      email = UserMailer.access_code(email_address, subject, message, code).deliver
      ActionMailer::Base.deliveries.should_not be_empty
      email.to.should == [email_address]
      email.from.should == [MuckEngine.configuration.from_email]
      email.subject.should == subject
      email.body.should include(message)
      email.body.should include(code)
    end
    
  end
end
