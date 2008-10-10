class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.string  :title
      t.text    :body
      t.string  :slug
      t.integer :version, :default=>1
      t.boolean :home_page, :default=>false
      t.boolean :locked, :default=>false
      t.boolean :enabled, :default=>false
      t.timestamps
    end
    
    create_table :page_versions do |t|
      t.integer :page_id
      t.integer :version
      t.string  :title
      t.text    :body
      t.string  :slug
      t.timestamps
    end

  end

  def self.down
    drop_table :pages
    drop_table :page_versions
  end
end
