# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090318152317) do

  create_table "bills", :force => true do |t|
    t.integer  "sponsor_id"
    t.string   "title"
    t.text     "description"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cosponsor_ids"
  end

  create_table "bios", :force => true do |t|
    t.string   "bioguide_id"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committee_memberships", :force => true do |t|
    t.integer  "committee_id"
    t.string   "govtrack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "location_data"
    t.string   "postal_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
