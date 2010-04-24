require 'thread'
require 'net/http'

threads = nil
responses = Queue.new

threads = (0..99).map do |i|
 Thread.new do
    url = "http://localhost:3000/api/v1/entries/#{i}"
    body = Net::HTTP.get(URI.parse(url))
    responses.push([url, body])
  end
end
threads.each {|thread| thread.join}    

# do something with the responses