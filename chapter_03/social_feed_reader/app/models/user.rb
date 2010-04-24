class User < ActiveRecord::Base
  has_many :follows
  has_many :followed_users, :through => :follows
  has_many :followings, :class_name => "Follow",
    :foreign_key => :followed_user_id
  has_many :followers, :through => :followings,
    :source => :user
  has_many :comments
  has_many :up_votes
  has_many :down_votes
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :activities,
    :conditions => ["activities.following_user_id IS NULL"]
  has_many :followed_activities, :class_name => "Activity",
    :foreign_key => :following_user_id
end


# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  bio        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

