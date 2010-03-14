class PauldixEntries::Entry
  class << self; attr_accessor :hydra; end;

  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attr_accessor :id, :title, :body, :author, :published_time, 
                :attributes, :rating, :rating_total
  
  validates_presence_of :title, :published_time
  
  def initialize(attributes_or_json)
    if attributes_or_json.is_a? String
      from_json(attributes_or_json)
      @attributes = @attributes.with_indifferent_access
    else
      @attributes = attributes_or_json.with_indifferent_access
    end

    @id = @attributes[:id]
    @title = @attributes[:title]
    @body  = @attributes[:body]
    @author = @attributes[:author]
    @published_time = @attributes[:published_time]
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end
  
  def self.get_ids(ids, &block)
    request = Typhoeus::Request.new(get_ids_uri(ids))

    request.on_complete do |response|
      json = Yajl::Parser.parse(response.body)

      entries = ids.map do |id|
        new(json[id].merge("id" => id))
      end
      
      block.call(entries)
    end
    
    hydra.queue(request)
  end
  
  def self.get_ids_uri(ids)
    "http://localhost:3000/api/v1/entries?ids=#{ids.join(",")}"
  end
  
  def self.stub_all_ids(ids)
    body = ids.inject({}) do |result, id|
      result[id] = {
        :title => "test title",
        :body => "something",
        :author => "whatevs",
        :published_time => Time.now}
      result
    end.to_json

    response = Typhoeus::Response.new(
      :code => 200, 
      :headers => "", 
      :body => body,
      :time => 0.3)
    hydra.stub(:get, get_ids_uri(ids)).and_return(response)
  end
end
