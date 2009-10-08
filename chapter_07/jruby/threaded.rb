require 'net/http'
include Java
import 'java.util.concurrent.Executors'

class Request
  include java.util.concurrent.Callable
  def initialize(url)
    @url = url
  end
  
  def call
    Net::HTTP.get(URI.parse(@url))
  end
end

thread_pool = Executors.new_fixed_thread_pool(50)

futures = []
100.times do |i|
  request = Request.new("http://localhost:3000/entries/#{i}")
  futures << thread_pool.submit(request)
end

results = futures.map {|f| f.get}
# do something with results

thread_pool.shutdown
