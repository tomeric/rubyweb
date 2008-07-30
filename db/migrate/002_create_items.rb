class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string     :title
      t.string     :url
      t.text       :content
      t.string     :byline
      t.references :user
      t.timestamps
      t.integer    :comments_count, :default => 0
    end
  end

  def self.down
    drop_table :items
  end
end
