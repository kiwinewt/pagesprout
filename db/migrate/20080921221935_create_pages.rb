class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.datetime :deleted_at
      t.integer :version, :default=>1
      t.boolean :home_page
      t.timestamps
    end
    
    create_table :page_versions do |t|
      t.integer :page_id
      t.integer :version
      t.string  :title
      t.text    :body
      t.string :slug
      t.timestamps
    end

  end

  def self.down
    drop_table :pages
    drop_table :page_versions
  end
end
