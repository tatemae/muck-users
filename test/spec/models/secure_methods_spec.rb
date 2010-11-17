require File.dirname(__FILE__) + '/../spec_helper'

describe "SecureMethods" do

  describe "check creator method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if creators are equal" do
      @user.send(:check_creator, @user).should be_true
    end
    it "should return false if creators are different" do
      @another_user.send(:check_creator, @user).should be_false
    end
  end
  describe "check user method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if users are equal" do
      @user.send(:check_user, @user).should be_true
    end
    it "should return false if users are different" do
      @another_user.send(:check_user, @user).should be_false
    end
  end
  describe "check sharer method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if sharers are equal" do
      @user.send(:check_sharer, @user).should be_true
    end
    it "should return false if sharers are different" do
      @another_user.send(:check_sharer, @user).should be_false
    end
  end
  describe "check method" do
    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:user)
    end
    it "should  return false when user is nil" do
      @user.send(:check, nil, :user_id).should be_false
    end
    it "should return true when user is different but an admin" do
      @admin.add_to_role('administrator')
      @admin.reload
      @user.send(:check, @admin, :user_id).should be_true
    end
  end
  
end
