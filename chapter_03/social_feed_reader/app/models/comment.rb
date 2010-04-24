class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry, :counter_cache => true

  after_create {|record| CommentActivity.write(record)}
end


# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  entry_id   :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

