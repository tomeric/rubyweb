class RenameItemsUrlToSlug < ActiveRecord::Migration
  def self.up
    rename_column :items, :url, :slug
  end

  def self.down
    rename_column :items, :slug, :url
  end
end
