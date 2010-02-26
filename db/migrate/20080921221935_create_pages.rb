class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id, :default => 0
      t.string  :title
      t.text    :body
      t.string  :permalink
      t.string  :keywords
      t.integer :version, :default => 1
      t.boolean :home_page, :default => false
      t.boolean :locked, :default => false
      t.boolean :enabled, :default => true
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
