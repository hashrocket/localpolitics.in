class CreateCommitteeMemberships < ActiveRecord::Migration
  def self.up
    create_table :committee_memberships do |t|
      t.integer :committee_id
      t.string :govtrack_id

      t.timestamps
    end
  end

  def self.down
    drop_table :committee_memberships
  end
end
