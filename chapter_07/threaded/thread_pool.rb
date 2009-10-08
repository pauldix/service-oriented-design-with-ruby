require 'thread'
require 'net/http'

url_queue = Queue.new
thread_pool = []
responses = Queue.new

50.times do
  thread_pool << Thread.new do
    loop do
      url = url_queue.pop
      responses.push([url, Net::HTTP.get(URI.parse(url))])
    end
  end
end  

100.times do |i|
  url_queue.push "http://localhost:3000/api/v1/entries/#{i}"
end
  
responses = []
while responses.size < 99
  responses << @responses.pop
end

# do something with the responses