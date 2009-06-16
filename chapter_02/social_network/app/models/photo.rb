class Photo < ActiveRecord::Base
  has_attached_file :file, 
                    :styles => { :medium => "300x300>", 
                                 :thumb => "100x100>" }
  belongs_to :user

  after_create {|comment| Stream.write(comment)}
end

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
