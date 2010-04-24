class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  after_create {|record| SubscriptionActivity.write(record)}
end


# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

