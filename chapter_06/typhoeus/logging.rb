require 'rubygems'
require 'typhoues'
require 'logger'

logger = Logger.new("response_times.txt")
hydra = Typhoeus::Hydra.new
hydra.on_complete do |response|
  if response.code >= 200 && response.code < 500
    logger.info("#{response.request.url} in #{response.time} seconds")
  else
    logger.info("#{response.request.url} FAILED")
  end
end
