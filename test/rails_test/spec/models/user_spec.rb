# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean(1)      not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  created_at          :datetime
#  activated_at        :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  url_key             :string(255)
#  access_code_id        :integer(4)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  it { should have_many :permissions}
  it { should have_many :roles}
  
  it { should scope_by_latest }
  it { should scope_by_newest }
  it { should scope_by_oldest }
  it { should scope_newer_than }
  it { should scope_older_than }
    
  #it { should ensure_length_of(:email).is_at_least(6).is_at_most(255) }
  
  it { should allow_value('a@x.com').for(:email) }
  it { should allow_value('de.veloper@example.com').for(:email) }
  it { should_not allow_value('example.com').for(:email) }
  it { should_not allow_value('@example.com').for(:email) }
  it { should_not allow_value('developer@example').for(:email) }
  it { should_not allow_value('developer').for(:email) }

  it { should_not allow_value('test#guy').for(:login) }  
  it { should_not allow_value('test guy').for(:login) }
  it { should_not allow_value('test.guy').for(:login) }
  it { should_not allow_value('testguy!').for(:login) }
  it { should_not allow_value('test@guy.com').for(:login) }
  it { should allow_value('testguy').for(:login) }
  it { should allow_value('test-guy').for(:login) }

  it { should belong_to :access_code}
  
  it { should_not allow_mass_assignment_of :crypted_password }
  it { should_not allow_mass_assignment_of :password_salt } 
  it { should_not allow_mass_assignment_of :persistence_token } 
  it { should_not allow_mass_assignment_of :single_access_token } 
  it { should_not allow_mass_assignment_of :perishable_token } 
  it { should_not allow_mass_assignment_of :login_count }
  it { should_not allow_mass_assignment_of :failed_login_count } 
  it { should_not allow_mass_assignment_of :last_request_at } 
  it { should_not allow_mass_assignment_of :last_login_at } 
  it { should_not allow_mass_assignment_of :current_login_at } 
  it { should_not allow_mass_assignment_of :current_login_ip } 
  it { should_not allow_mass_assignment_of :last_login_ip } 
  it { should_not allow_mass_assignment_of :terms_of_service } 
  it { should_not allow_mass_assignment_of :time_zone } 
  it { should_not allow_mass_assignment_of :disabled_at } 
  it { should_not allow_mass_assignment_of :activated_at } 
  it { should_not allow_mass_assignment_of :created_at }
  it { should_not allow_mass_assignment_of :updated_at }
                 
  describe "named scopes" do
    before(:each) do
      @active_user = Factory(:user, :activated_at => DateTime.now)
      @inactive_user = Factory(:user, :activated_at => nil)
    end
    describe "active" do
      it "should find active user" do
        User.active.should include(@active_user)
      end
      it "should not find inactive user" do
        User.active.should_not include(@inactive_user)
      end
    end
    describe "inactive" do
      it "should find inactive user" do
        User.inactive.should include(@inactive_user)
      end
      it "should not find active user" do
        User.inactive.should_not include(@active_user)
      end
    end
    describe "by_login_alpha" do
      before(:each) do
        @user1 = Factory(:user, :login => 'atest')
        @user2 = Factory(:user, :login => 'btest')
      end
      it "should order by login" do
        users = User.by_login_alpha
        users.index(@user1).should < users.index(@user2)
      end
    end
    describe "by_login" do
      before(:each) do
        @zuser = Factory(:user, :login => 'zasdf')
        @xuser = Factory(:user, :login => 'xasdf')
      end
      it "should find login by character match" do
        User.by_login('z').should include(@zuser)
      end
      it "should not find login that doesn't match" do
        User.by_login('x').should_not include(@zuser)
      end
      it "should not find login that start with a matching character" do
        User.by_login('asdf').should be_blank
      end
    end
  end

  describe "terms of service set to false" do
    before(:each) do
      @user = Factory.build(:user, :terms_of_service => false)
    end
    it "should not create the user" do
      @user.should_not be_valid
      @user.errors.full_messages.should include(I18n.translate('muck.users.terms_of_service_required'))      
    end
  end

  describe "a user" do
    it "should have full name" do
      lambda {
        user = Factory(:user, :first_name => 'quent', :last_name => 'smith')
        user.should_not be_new_record, "#{user.errors.full_messages.to_sentence}"
        user.full_name.should == 'quent smith'
      }.should change(User, :count)
    end

    it "should show display name if first and last name is blank" do
      user = Factory(:user, :first_name => '', :last_name => '')
      user.display_name.should ==  user.full_name
      user.display_name.should ==  user.login
    end

    it "should not display sensitive information when converted to xml" do
      @user = Factory(:user)
      @user.to_xml.should_not be_blank
      @user.to_xml.should_not include("crypted_password")
      @user.to_xml.should_not include("password_salt")
      @user.to_xml.should_not include("persistence_token")
      @user.to_xml.should_not include("single_access_token") 
    end

    it "should return the first_name or display_name" do
      @user = Factory(:user)
      @user.short_name.should == CGI::escapeHTML(@user.first_name) || @user.display_name
    end
  
    it "should Create a new user and lowercase the login" do
      lambda {
        user = Factory(:user, :login => 'TESTGUY')
        user.should_not be_new_record
        user.login.should == 'testguy'
      }.should change(User, :count)
    end

    it "should Not allow login with dot" do
      user = Factory.build(:user, :login => 'test.guy')
      user.should_not be_valid
    end

    it "should Not allow login with dots" do
      user = Factory.build(:user, :login => 'test.guy.guy')
      user.should_not be_valid
    end

    it "should Allow login with dash" do
      user = Factory.build(:user, :login => 'test-guy')
      user.should be_valid
    end

    it "should Not allow login with '@'" do
      user = Factory.build(:user, :login => 'testguy@example.com')
      user.should_not be_valid
    end         

    it "should Not allow login with '!'" do
      user = Factory.build(:user, :login => 'testguy!')
      user.should_not be_valid
    end

    it "should require login" do
      lambda {
        u = Factory.build(:user, :login => nil)
        u.should_not be_valid
        u.errors[:login].should_not be_empty
      }.should_not change(User, :count)
    end

    it "should require password" do
      lambda {
        u = Factory.build(:user, :password => nil)
        u.should_not be_valid
        u.errors[:password].should_not be_empty
      }.should_not change(User, :count)
    end

    it "should require password confirmation" do
      lambda {
        u = Factory.build(:user, :password_confirmation => nil)
        u.should_not be_valid
        u.errors[:password_confirmation].should_not be_empty
      }.should_not change(User, :count)
    end

    it "should require require email" do
      lambda {
        u = Factory.build(:user, :email => nil)
        u.should_not be_valid
        u.errors[:email].should_not be_empty
      }.should_not change(User, :count)
    end
  end

  describe "activating/deactivating users" do
    describe "inactive users" do
      before(:each) do
        @user = Factory(:user, :activated_at => nil)
      end
      it "should have at least one inactive user" do
        User.inactive_count.should > 0
      end
      it "should be able to activate all users" do
        User.activate_all.should be_true
        User.inactive_count.should == 0
      end
    end

    describe "activate!" do
      before(:each) do
        @user_inactive = Factory(:user, :activated_at => nil )
      end
      it "should activate the user" do
        @user_inactive.should_not be_active
        @user_inactive.activate!
        @user_inactive.reload
        @user_inactive.should be_active
      end
    end

    describe "deactivate!" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should activate the user" do
        @user.should be_active
        @user.deactivate!
        @user.reload
        @user.should_not be_active
      end
    end
  end
  
  describe "emails" do
    before(:all) do
      @email = mock(:email, :deliver)
    end
    describe "deliver_welcome_email" do
      before(:each) do
        @user = Factory(:user)
        @send_welcome = MuckUsers.configuration.send_welcome
        MuckUsers.configuration.send_welcome = true
      end
      after(:each) do
        MuckUsers.configuration.send_welcome = @send_welcome
      end
      it "should deliver activation instructions" do
        UserMailer.should_receive(:welcome_notification).with(@user).and_return(@email)
        @user.deliver_welcome_email
      end
    end
  
    describe "deliver_activation_confirmation" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should deliver activation instructions" do
        @user.should_receive(:reset_perishable_token!)
        UserMailer.should_receive(:activation_confirmation).with(@user).and_return(@email)
        @user.deliver_activation_confirmation!
      end
    end
  
    describe "deliver_activation_instructions" do
      before(:each) do
        @user = Factory(:user)
      end
      it "should deliver activation instructions" do
        @user.should_receive(:reset_perishable_token!)
        UserMailer.should_receive(:activation_instructions).with(@user).and_return(@email)
        @user.deliver_activation_instructions!
      end
    end
  
    describe "deliver_password_reset_instructions" do
      before(:each) do
        @user_inactive = Factory(:user, :activated_at => nil)
        @user_active = Factory(:user)
      end
      it "should send password reset instructions" do
        UserMailer.should_receive(:password_reset_instructions).and_return(@email)
        @user_active.deliver_password_reset_instructions!
      end
      it "should send not active instructions" do
        UserMailer.should_receive(:password_not_active_instructions).and_return(@email)
        @user_inactive.deliver_password_reset_instructions!
      end
    end
  end
  
  describe "user exists" do
    before(:each) do
      @user = Factory(:user, :login => 'atestguytoo', :email => 'atestguytoo@example.com')
    end
    it "should find user with login" do
      User.login_exists?('atestguytoo').should be_true
    end
    it "should find user with email" do
      User.email_exists?('atestguytoo@example.com').should be_true
    end
  end

  describe "user does not exist" do
    before(:each) do
      @user = Factory(:user, :login => 'atestguytoo', :email => 'atestguytoo@example.com')
    end
    it "should NOT find user with login" do
      User.login_exists?('nonexistentuser').should be_false
    end
    it "should NOT find user with email" do
      User.email_exists?('nonexistentuser@example.com').should be_false
    end
  end

  describe "check user roles" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should be in admin role" do
      @user.add_to_role('administrator')
      @user.reload
      @user.should be_admin
    end
    it "should add the user to the specified role" do
      @user.add_to_role('bla')
      @user.reload
      @user.has_role?('bla').should be_true
    end
    it "should find the user in any role" do
      @user.add_to_role('bla')
      @user.add_to_role('foo')
      @user.add_to_role('bar')
      @user.reload
      @user.any_role?('bla', 'foo').should be_true
      @user.any_role?('bar').should be_true
      @user.any_role?('alb').should be_false
    end
    it "should only add the user to the given role once" do
      @user.roles.delete_all
      @user.add_to_role('bla')
      @user.add_to_role('bla')
      @user.reload
      @user.roles.count.should == 1
    end
  end

  describe "user can edit" do
    before(:each) do
      @user = Factory(:user)
      @anotheruser = Factory(:user)
    end
    it "should be false if user is nil" do
      @user.can_edit?(nil).should be_false
    end
    it "should be false if user is not self or an admin" do
      @user.can_edit?( @anotheruser ).should be_false
      @anotheruser.admin?.should be_false
      @user.can_edit?( @anotheruser ).should be_false
    end
    it "should be true if user is self" do
      @user.can_edit?( @user ).should be_true
    end
    it "should be true if user is an admin" do
      @anotheruser.add_to_role('administrator')
      @anotheruser.reload
      @user.can_edit?( @anotheruser ).should be_true
    end
  end
end