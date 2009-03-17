class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :sponsor_id
      t.string :title
      t.text :description
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
