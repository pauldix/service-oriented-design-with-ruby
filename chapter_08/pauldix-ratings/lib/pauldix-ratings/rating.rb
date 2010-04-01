class PauldixRatings::Rating
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  ATTRIBUTES = [:user_id, :entry_id, :vote]
  attr_accessor *ATTRIBUTES
  
  validates_presence_of :user_id, :entry_id
  validates_inclusion_of :vote, :in => %w[up down]
  
  def initialize(attributes = {})
    self.attributes = attributes
  end
  
  def attributes
    ATTRIBUTES.inject(
      ActiveSupport::HashWithIndifferentAccess.new
      ) do |result, key|

      result[key] = read_attribute_for_validation(key)
      result
    end
  end
  
  def attributes=(attrs)
    attrs.each_pair {|k, v| send("#{k}=", v)}
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
      @exchange = PauldixRatings::Config.bunny_client.exchange(
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
