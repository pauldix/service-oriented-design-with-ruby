require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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
#  rating            :integer
#  entry_id          :integer
#  content           :text
#  following_user_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#

