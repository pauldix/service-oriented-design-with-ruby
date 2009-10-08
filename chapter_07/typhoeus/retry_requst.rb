require 'rubygems'
require 'typhoeus'

hydra = Typhoeus::Hydra.new
request = Typhoeus::Request.new("http://localhost:3000/fail/1")
request.on_complete do |response|
  if response.code == 500 && request.failures < 3
    hydra.queue(request)
  elsif request.failures >= 3
    # log stuff
  else
    # do stuff
  end
end
hyra.queue(request)
hydra.run
