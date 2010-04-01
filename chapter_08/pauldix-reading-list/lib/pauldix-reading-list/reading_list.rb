class PauldixReadingList::ReadingList
  attr_accessor :entry_ids, :previous_page, :next_page
  
  def initialize(json, options = {})
    json = Yajl::Parser.parse(json)
    @next_page = json["next_page"]
    @entry_ids = json["entry_ids"]
    @previous_page = json["previous_page"]
    @includes = options[:include]
  end

  def request_rating_totals
    PauldixRatings::RatingTotal.get_ids(entry_ids) do |ratings|
      @rating_totals = ratings
    end
  end
  
  def request_entries
    PauldixEntries::Entry.get_ids(entry_ids) do |entries|
      @entries = entries
    end
  end
  
  def entries
    return @entries if @includes_run
    
    include_rating_total = @includes.include?(:rating_total)
    
    if @includes.include?(:rating_total)
      @entries.each_with_index do |entry, index|
        entry.rating_total = @rating_totals[index]
      end
    end

    @includes_run = true
    @entries
  end
  
  def self.for_user(user_id, options = {}, &block)
    includes = options[:include] || []
    
    request = Typhoeus::Request.new(get_by_id_uri(user_id))
    request.on_complete do |response|
      list = new(response.body, options)
      
      list.request_entries if includes.include?(:entry)
      list.request_rating_totals if includes.include?(:rating_total)
      
      block.call(list)
    end
    
    PauldixReadingList::Config.hydra.queue(request)
  end
  
  def self.get_by_id_uri(user_id)
    "http://#{PauldixReadingList::Config.host}/api/v1/reading_list/users/#{user_id}"
  end
  
  def self.stub_all_user_ids_with_ids(user_ids, ids)
    body = {
      :entry_ids => ids
    }.to_json
    
    response = Typhoeus::Response.new(
      :code => 200, 
      :headers => "", 
      :body => body,
      :time => 0.3)

    user_ids.each do |user_id|
      PauldixReadingList::Config.hydra.stub(:get, 
        get_by_id_uri(user_id)).and_return(response)
    end
  end
end
