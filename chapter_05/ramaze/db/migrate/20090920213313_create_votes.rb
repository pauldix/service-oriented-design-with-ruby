class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :entry_id
      t.string :user_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
