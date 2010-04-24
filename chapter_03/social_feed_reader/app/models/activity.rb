class Activity < ActiveRecord::Base
  belongs_to :user

  def self.write(event)
    create(event.attributes)
    event.user.followers.each do |user|
      create(event.attributes.merge(:following_user_id => user.id))
    end
  end
end

class CommentActivity < Activity
end

class SubscriptionActivity < Activity
  belongs_to :feed
end

class VoteActivity < Activity
end

class FollowActivity < Activity
  belongs_to :followed_user, :class_name => "User"
end


# == Schema Information
#
# Table name: activities
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  type              :string(255)
#  feed_id           :integer
#  followed_user_id  :integer
#  entry_id          :integer
#  content           :text
#  following_user_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

