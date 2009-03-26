class CreateSenatorComparisons < ActiveRecord::Migration
  def self.up
    create_table :senator_comparisons do |t|
      t.integer :govtrack_id_1
      t.integer :govtrack_id_2
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :senator_comparisons
  end
end
