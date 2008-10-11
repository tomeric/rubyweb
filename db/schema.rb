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

ActiveRecord::Schema.define(:version => 4) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.string   "byline"
    t.integer  "user_id",    :limit => 11
    t.integer  "item_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.string   "byline"
    t.integer  "user_id",        :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :limit => 11, :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                      :null => false
    t.string   "email",                                                      :null => false
    t.string   "fullname"
    t.string   "url"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.boolean  "approved_for_feed",                       :default => false
    t.boolean  "admin",                                   :default => false
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
