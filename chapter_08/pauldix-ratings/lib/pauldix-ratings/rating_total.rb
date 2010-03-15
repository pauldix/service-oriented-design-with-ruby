class PauldixRatings::RatingTotal
  attr_accessor :up_count, :down_count, :entry_id, :entry
  
  def initialize(json)
    @up_count = json["up"]
    @down_count = json["down"]
    @entry_id = json["entry_id"]
  end
  
  def self.get_ids(ids, &block)
    request = Typhoeus::Request.new(get_ids_uri(ids))

    request.on_complete do |response|      
      json = Yajl::Parser.parse(response.body)
      
      ratings = ids.map do |id|
        new(json[id])
      end
      
      block.call(ratings)
    end
    
    PauldixRatings::Config.hydra.queue(request)
  end
  
  def self.get_ids_uri(ids)
    "http://#{PauldixRatings::Config.host}/api/v1/ratings/entries/totals?ids=#{ids.join(",")}"
  end
  
  def self.stub_all_ids(ids)
    body = ids.inject({}) do |result, id|
      result[id] = {
        :up => rand(100),
        :down => rand(100)}
      result
    end.to_json

    response = Typhoeus::Response.new(
      :code => 200, 
      :headers => "", 
      :body => body,
      :time => 0.3)
    PauldixRatings::Config.hydra.stub(:get, get_ids_uri(ids)).and_return(response)
  end
end
