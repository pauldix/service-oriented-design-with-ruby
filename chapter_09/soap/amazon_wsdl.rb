require 'rubygems'
require 'savon'

client = 
  Savon::Client.new("http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl")
puts "SOAP Endpoint: #{client.wsdl.soap_endpoint}"
puts "Namespace: #{client.wsdl.namespace_uri}"
puts "Actions: #{client.wsdl.soap_actions.join(', ')}"
