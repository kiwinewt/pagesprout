class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :permalink
      t.boolean :enabled, :default=>false
      t.integer :blog_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
