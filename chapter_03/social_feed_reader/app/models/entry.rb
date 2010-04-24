class Entry < ActiveRecord::Base
  belongs_to :feed
  has_many :comments
end


# == Schema Information
#
# Table name: entries
#
#  id               :integer         not null, primary key
#  feed_id          :integer
#  title            :string(255)
#  url              :string(255)
#  content          :text
#  published_date   :datetime
#  up_votes_count   :integer
#  down_votes_count :integer
#  comments_count   :integer
#  created_at       :datetime
#  updated_at       :datetime
#

