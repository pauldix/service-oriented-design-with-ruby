require 'rubygems'
require 'savon'
require 'hmac'
require 'hmac-sha2'
require 'base64'  

class AmazonProductAdvertisingAPI
  def initialize(aws_access_key_id, aws_secret_key)
    @aws_access_key_id = aws_access_key_id
    @aws_secret_key = aws_secret_key
    @client = 
      Savon::Client.new("https://ecs.amazonaws.com/onca/soap?Service=AWSECommerceService")
  end
  
  def timestamp_and_signature(operation)
    timestamp = Time.now.gmtime.iso8601

    hmac = HMAC::SHA256.new(@aws_secret_key)
    hmac.update("#{operation}#{timestamp}")
    # chomp to get rid of the newline
    signature = Base64.encode64(hmac.digest).chomp

    [timestamp, signature]
  end
  
  def search(query)
    operation = "ItemSearch"
    timestamp, signature = timestamp_and_signature(operation)
    
    @client.ItemSearch! do |soap|
      soap.namespace = 
        "http://webservices.amazon.com/AWSECommerceService/2009-11-01"
      soap.input     = operation
      soap.body      = {
        "SearchIndex" => "Books",
        "Keywords" => query,
        "Timestamp" => timestamp,
        "AWSAccessKeyId" => @aws_access_key_id,
        "Signature" => signature
      }
    end
  end
end

aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
aws_secret_key = ENV["AWS_SECRET_KEY"]

Savon::Request.log = false
api = AmazonProductAdvertisingAPI.new(aws_access_key_id, aws_secret_key)
results = api.search("service oriented design with ruby")
results.to_hash[:item_search_response][:items][:item].each do |item|
  author = item[:item_attributes][:author]
  author = author.is_a?(String) ? author : author.join(", ")
  puts "#{item[:item_attributes][:title]} by #{author}"
end
