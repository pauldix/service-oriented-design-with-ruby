class PauldixRatings::Rating
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attr_accessor :user_id, :entry_id, :vote
  
  validates_presence_of :user_id, :entry_id
  validates_inclusion_of :vote, :in => %w[up down]
  
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
    send(key)
  end

  def save
    return false unless valid?
    
    request = Typhoeus::Request.new(
      "/api/v1/ratings/entries/#{entry_ids}/users/#{user_id}/vote",
      :method => :post,
      :body => {:vote => vote}.to_json)
    
    PauldixRatings.hydra.queue(request)
    PauldixRatings.hydra.run
  
    if response.code == 200
      return self
    else
      errors.add(:http_code, response.code)
      errors.add(:http_response_body, response.body)
      return nil
    end
  end
  
  def save_asynchronous
    unless @exchange
      @exchange = PauldixRatings.bunny_client.exchange(
        "ratings", :type => :topic, :durable => :true)
    end
    
    @exchange.publish(to_json, :key => vote)
  end
  
  def up?
    @vote == "up"
  end
  
  def down?
    @vote == "down"
  end
end
