class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.string :permalink
      t.string  :keywords
      t.boolean :enabled, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
