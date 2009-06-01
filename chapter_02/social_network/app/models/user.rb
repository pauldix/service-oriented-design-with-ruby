# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  email      :string(255)
#  password   :string(255)
#  salt       :string(255)
#  photo_id   :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  belongs_to :photo
  has_one    :stream
  has_many   :friendships
  has_many   :friends, :through => :friendships
end
