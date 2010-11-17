require File.dirname(__FILE__) + '/../spec_helper'

describe Role do

  it { should validate_presence_of :rolename }
  it { should have_many :permissions }
  it { should have_many :users }

  describe "Create new role" do
    it "should should create a new role" do
      lambda {
        new_role = Role.create(:rolename => "new role")
        new_role.save
      }.should change(Role, :count)
    end
  end
  
end