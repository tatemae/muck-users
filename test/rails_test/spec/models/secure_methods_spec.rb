require File.dirname(__FILE__) + '/../spec_helper'

class SecureMethodsTest < ActiveSupport::TestCase

  describe "check creator method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if creators are equal" do
      assert @user.send(:check_creator, @user)
    end
    it "should return false if creators are different" do
      assert_equal false, @another_user.send(:check_creator, @user)
    end
  end
  describe "check user method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if users are equal" do
      assert @user.send(:check_user, @user)
    end
    it "should return false if users are different" do
      assert_equal false, @another_user.send(:check_user, @user)
    end
  end
  describe "check sharer method" do
    before(:each) do
      @user = Factory(:user)
      @another_user = Factory(:user)
    end
    it "should return true if sharers are equal" do
      assert @user.send(:check_sharer, @user)
    end
    it "should return false if sharers are different" do
      assert_equal false, @another_user.send(:check_sharer, @user)
    end
  end
  describe "check method" do
    before(:each) do
      @user = Factory(:user)
      @admin = Factory(:user)
    end
    it "should  return false when user is nil" do
      assert_equal false, @user.send(:check, nil, :user_id)
    end
    it "should return true when user is different but an admin" do
      @admin.add_to_role('administrator')
      @admin.reload
      assert @user.send(:check, @admin, :user_id)
    end
  end
end
