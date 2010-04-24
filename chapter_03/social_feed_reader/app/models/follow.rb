class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followed_user, :class_name => "User"

  after_create {|record| FollowActivity.write(record)}
end


# == Schema Information
#
# Table name: follows
#
#  id               :integer         not null, primary key
#  user_id          :integer
#  followed_user_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

