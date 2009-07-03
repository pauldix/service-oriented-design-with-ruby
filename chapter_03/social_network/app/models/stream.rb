class Stream < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity, :polymorphic => true
  
  def write(activity)
    activity.user.friends.each do |friend|
      friend.stream.create(:activity => activity)
    end
  end
end

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
