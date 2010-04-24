require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
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

