class User < ActiveRecord::Base
  validates_uniqueness_of :name, :email
  def to_json
    super(:except => :password)
  end
end