class AddCosponsorIdsToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :cosponsor_ids, :text
  end

  def self.down
    remove_column :bills, :cosponsor_ids
  end
end
