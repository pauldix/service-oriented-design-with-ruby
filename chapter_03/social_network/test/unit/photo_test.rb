# == Schema Information
#
# Table name: photos
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  title             :string(255)
#  caption           :text
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
