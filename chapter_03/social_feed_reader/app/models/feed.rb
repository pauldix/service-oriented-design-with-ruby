class Feed < ActiveRecord::Base
  has_many :entries
  has_many :subscriptions
  has_many :users, :through => :subscriptions
end


# == Schema Information
#
# Table name: feeds
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  url        :string(255)
#  feed_url   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

