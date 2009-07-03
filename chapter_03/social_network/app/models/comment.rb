class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :polymorphic => true
  
  after_create {|comment| Stream.write(comment)}
end

# == Schema Information
#
# Table name: comments
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  parent_id   :integer
#  parent_type :string(255)
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#
