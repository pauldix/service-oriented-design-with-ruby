class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  after_create do |friendship| 
    Friendship.create(:user => friendship.friend, 
                      :friend => friendship.user)
  end
end

# == Schema Information
#
# Table name: friendships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  confirmed  :boolean
#  created_at :datetime
#  updated_at :datetime
#
