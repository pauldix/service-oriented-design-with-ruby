require 'rubygems'
require 'spec'
require 'spec/interop/test'

RESPONSE_XML = File.read("#{File.dirname(__FILE__)}/ec2_describe_instances_response.xml")
