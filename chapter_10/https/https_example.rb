require 'uri'
require 'net/https'

uri = URI.parse(ARGV[0] || "https://mail.google.com")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.ca_file = File.join(File.dirname(__FILE__), "cacert.pem")
http.start do
  puts http.get("/")
end
