class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string :type
      t.integer :feed_id
      t.integer :followed_user_id
      t.integer :entry_id
      t.text :content
      t.integer :following_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
