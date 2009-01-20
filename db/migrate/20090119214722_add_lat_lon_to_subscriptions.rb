class AddLatLonToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :latitude,  :string
    add_column :subscriptions, :longitude, :string
  end

  def self.down
    remove_column :subscriptions, :longitude
    remove_column :subscriptions, :latitude
  end
end
