require 'rubygems'
require 'nokogiri'

class DescribeInstancesResponse
  attr_reader :reservation_sets
  
  def initialize(reservation_sets)
    @reservation_sets = reservation_sets
  end
  
  def self.parse(xml)
    doc = Nokogiri::XML(xml)
    
    sets = doc.css("reservationSet > item").map do |item|
      ReservationSet.build(item)
    end
    
    new(sets)
  end
end

class ReservationSet
  attr_reader :security_group, :instances, :reservation_id
  def initialize(attributes)
    @security_group = attributes[:security_group]
    @reservation_id = attributes[:reservation_id]
    @instances      = attributes[:instances]
  end
  
  def self.build(xml)
    instances = xml.css("instancesSet > item").map do |item|
      Instance.build(item)
    end
    
    new(
      :security_group => xml.css("groupId").text,
      :instances => instances,
      :reservation_id => xml.css("reservationId").text)
  end
end

class Instance
  attr_reader :id, :image_id, :state, :private_dns_name, 
              :dns_name, :key_name, :type, :launch_time,
              :availability_zone
  
  def initialize(attributes)
    @id = attributes[:id]
    @image_id = attributes[:image_id]
    @state = attributes[:state]
    @private_dns_name = attributes[:private_dns_name]
    @dns_name = attributes[:dns_name]
    @key_name = attributes[:key_name]
    @type = attributes[:type]
    @launch_time = attributes[:launch_time]
    @availability_zone = attributes[:availability_zone]
  end
  
  def self.build(xml)
    new(
      :id => xml.css("instanceId").text,
      :image_id => xml.css("imageId").text,
      :state => xml.css("instanceState > name").text,
      :private_dns_name => xml.css("privateDnsName").text,
      :dns_name => xml.css("dnsName").text,
      :key_name => xml.css("keyName").text,
      :type => xml.css("instanceType").text,
      :launch_time => xml.css("launchTime").text,
      :availability_zone => xml.css("availabilityZone").text)
  end
end
