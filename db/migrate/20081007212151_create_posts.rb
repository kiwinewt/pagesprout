class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :permalink
      t.string  :keywords
      t.boolean :enabled, :default => true
      t.integer :blog_id, :null => false
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
