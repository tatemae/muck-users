class AddProvidedByToAccessCodes < ActiveRecord::Migration
  def self.up
    add_column :access_codes, :provided_by_id, :integer
  end

  def self.down
    remove_column :access_codes, :provided_by_id
  end
end
