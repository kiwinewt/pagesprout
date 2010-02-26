class CreatePageVersions < ActiveRecord::Migration
  def self.up
    create_table :page_versions do |t|
      t.integer :page_id
      t.integer :version
      t.string  :title
      t.text    :body
      t.string  :permalink
      t.string  :keywords
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :page_versions
  end
end
