class User < ActiveRecord::Base
  belongs_to :photo
  has_one    :stream
  has_many   :friendships
  has_many   :friends, :through => :friendships
  validates_uniqueness_of :username
  validates_presence_of :password
  validates_presence_of :email
end

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
#  bio        :text
#  created_at :datetime
#  updated_at :datetime
#
