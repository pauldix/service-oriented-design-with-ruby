class PauldixReadingList::ReadingList
  class << self; attr_accessor :hydra; end;
  
  attr_accessor :entry_ids, :previous_page, :next_page
  
  def initialize(json, options = {})
    json = Yajl::Parser.parse(json)
    @next_page = json["next_page"]
    @entry_ids = json["entry_ids"]
    @previous_page = json["previous_page"]
    @includes = options[:include]
  end

  def request_rating_totals
    RatingTotal.get_ids(entry_ids) do |ratings|
      @rating_totals = ratings
    end
  end
  
  def request_entries
    Entry.get_ids(entry_ids) do |entries|
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
  
  def self.for_user_by_email(email, options = {}, &block)
    includes = options[:include] || []
    
    request = Typhoeus::Request.new(get_by_email_uri(email))
    request.on_complete do |response|
      list = new(response.body, options)
      
      list.request_entries if includes.include?(:entry)
      list.request_rating_totals if includes.include?(:rating_total)
      
      block.call(list)
    end
    
    hydra.queue(request)
  end
  
  def self.get_by_email_uri(email)
    "http://localhost:3000/api/v1/ratings/users/email/#{email}"
  end
  
  def self.stub_all_emails_with_ids(emails, ids)
    body = {
      :entry_ids => ids
    }.to_json
    
    emails.each do |email|
      response = Typhoeus::Response.new(
        :code => 200, 
        :headers => "", 
        :body => body,
        :time => 0.3)
      hydra.stub(:get, get_by_email_uri(email)).and_return(response)
    end
  end
end
