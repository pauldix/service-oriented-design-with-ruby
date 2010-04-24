class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :feed_id
      t.string :title
      t.string :url
      t.text :content
      t.datetime :published_date
      t.integer :up_votes_count
      t.integer :down_votes_count
      t.integer :comments_count

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
