class AddCongressInformationToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :number, :string
    add_column :bills, :session, :integer
    add_column :bills, :bill_type, :string

    Bill.update_all("session = 110")
  end

  def self.down
    remove_column :bills, :bill_type
    remove_column :bills, :session
    remove_column :bills, :number
  end
end
