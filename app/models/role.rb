# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  rolename   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  unloadable
  
  has_many :permissions, :dependent => :destroy
  has_many :users, :through => :permissions
  
  validates_presence_of :rolename
  validates_uniqueness_of :rolename

  named_scope :by_alpha, :order => 'roles.rolename ASC'

  # roles can be defined as symbols.  We want to store them as strings in the database
  def rolename= val
    write_attribute(:rolename, val.to_s)
  end

end

