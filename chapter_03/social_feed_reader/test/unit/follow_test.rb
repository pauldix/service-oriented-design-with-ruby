require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

