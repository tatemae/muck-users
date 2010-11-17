require File.dirname(__FILE__) + '/../spec_helper'

describe Permission do

  it {should belong_to :user}
  it {should belong_to :role}
  
  describe "Create new permission" do
    it "should should create a new permission" do
      lambda {
        user = Factory(:user)
        role = Factory(:role)
        permission = Permission.create(:user => user, :role => role)
        permission.save
      }.should change(Permission, :count)        
    end
  end
  
end
