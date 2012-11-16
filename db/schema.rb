# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121116173723) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token",      :null => false
  end

  add_index "accounts", ["provider"], :name => "index_accounts_on_provider"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "entries", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "entries", ["team_id"], :name => "index_entries_on_team_id"
  add_index "entries", ["user_id"], :name => "index_entries_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "invitation_key",                :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "entries_count",  :default => 0, :null => false
  end

  add_index "teams", ["invitation_key"], :name => "index_teams_on_invitation_key", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "name"
    t.string   "uid"
    t.datetime "location_updated_at"
    t.integer  "team_id"
    t.string   "city"
    t.string   "country"
  end

  add_index "users", ["team_id"], :name => "index_users_on_team_id"

end
