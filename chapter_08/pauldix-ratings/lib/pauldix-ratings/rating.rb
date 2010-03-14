class PauldixRatings::Rating
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attr_accessor :user_id, :entry_id
  
  validates_presence_of :user_id, :entry_id
  validates_inclusion_of :vote, :in => %q[up down]
  
  def initialize(attributes_or_json)
    if attributes_or_json.is_a? String
      from_json(attributes_or_json)
      @attributes = @attributes.with_indifferent_access
    else
      @attributes = attributes_or_json.with_indifferent_access
    end

    @entry_id = @attributes[:entry_id]
    @user_id = @attributes[:user_id]
    @vote = @attributes[:vote]
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end
  
  def up?
    @vote == "up"
  end
  
  def down?
    @vote == "down"
  end
end
