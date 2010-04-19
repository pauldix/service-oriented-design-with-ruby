class Vote < ActiveRecord::Base
  validates_inclusion_of :value, :in => %w[up down]
  validates_uniqueness_of :user_id, :scope => :entry_id
  validates_presence_of :entry_id
  validates_presence_of :user_id
  
  named_scope :up,   :conditions => ["value = ?", "up"]
  named_scope :down, :conditions => ["value = ?", "down"]
  named_scope :user_id, lambda {|user_id|
    {:conditions => ["user_id = ?", user_id]}}
  named_scope :entry_id, lambda {|entry_id|
    {:conditions => ["entry_id = ?", entry_id]}}
    
  def self.create_or_update(attributes)
    vote = Vote.find_by_entry_id_and_user_id(
      attributes[:entry_id], 
      attributes[:user_id])
    if vote
      vote.value = attributes[:value]
      vote.save
      vote
    else
      Vote.create(attributes)
    end
  end
  
  def self.voted_down_for_user_id(user_id, page, per_page = 25)
    entry_ids_for_user(user_id, "down", page, per_page)
  end
  
  def self.voted_up_for_user_id(user_id, page, per_page = 25)
    entry_ids_for_user(user_id, "up", page, per_page)
  end
  
  def self.entry_ids_for_user(user_id, value, page, per_page)
    votes = paginate_by_user_id_and_value(
      user_id, value, :page => page, :per_page => per_page)
    votes.map {|vote| vote.entry_id}
  end
end
