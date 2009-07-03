# == Schema Information
#
# Table name: streams
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  activity_id   :integer
#  activity_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class StreamTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
