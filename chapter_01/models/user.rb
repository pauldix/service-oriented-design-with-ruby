class User < ActiveRecord::Base
  validates_uniqueness_of :name, :email
  validates_presence_of :name, :email
  def to_json
    #super(:except => :password)
    super(:except => [:password, :created_at, :updated_at])
    #super(:only => [:name, :email, :bio])
  end
end