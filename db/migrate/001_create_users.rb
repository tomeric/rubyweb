class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login,                     :null => false
      t.string   :email,                     :null => false
      t.string   :fullname
      t.string   :url
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.boolean  :approved_for_feed,         :default => false
      t.boolean  :admin,                     :default => false
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.timestamps       
    end
  end

  def self.down
    drop_table "users"
  end
end
