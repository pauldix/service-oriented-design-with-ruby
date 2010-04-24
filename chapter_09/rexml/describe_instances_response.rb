require 'rexml/document'

class DescribeInstancesResponse
  attr_reader :reservation_sets
  
  def initialize(reservation_sets)
    @reservation_sets = reservation_sets
  end
  
  def self.parse(xml)
    doc = REXML::Document.new xml
    
    reservation_sets = []
    doc.elements.
      each("DescribeInstancesResponse/reservationSet/item"
        ) do |element|
        reservation_sets << ReservationSet.build(element)
    end
    
    new(reservation_sets)
  end
end

class ReservationSet
  attr_reader :security_group, :instances, :reservation_id
  def initialize(attributes)
    @security_group = attributes[:security_group]
    @reservation_id = attributes[:reservation_id]
    @instances      = attributes[:instances]
  end
  
  def self.build(xml_element)
    elements  = xml_element.elements
    instances = []
    
    elements.each("instancesSet/item") do |item|
      instances << Instance.build(item)
    end
    
    new(
      :security_group => elements["groupSet/item/groupId"].text,
      :reservation_id => elements["reservationId"].text,
      :instances      => instances)
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
  
  def self.build(xml_element)
    elements = xml_element.elements
    new(
      :id => elements["instanceId"].text,
      :image_id => elements["imageId"].text,
      :state => elements["instanceState/name"].text,
      :private_dns_name => elements["privateDnsName"].text,
      :dns_name => elements["dnsName"].text,
      :key_name => elements["keyName"].text,
      :type => elements["instanceType"].text,
      :launch_time => elements["launchTime"].text,
      :availability_zone => 
        elements["placement/availabilityZone"].text)
  end
end
