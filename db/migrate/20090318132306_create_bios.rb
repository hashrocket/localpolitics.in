class CreateBios < ActiveRecord::Migration
  def self.up
    create_table :bios do |t|
      t.string :bioguide_id
      t.text :bio

      t.timestamps
    end
  end

  def self.down
    drop_table :bios
  end
end
