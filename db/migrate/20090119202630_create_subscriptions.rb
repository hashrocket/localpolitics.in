class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string  :location_data
      t.string  :postal_code
      t.timestamps
    end
  end

  def self.down
    remove_table :subscriptions
  end
end
