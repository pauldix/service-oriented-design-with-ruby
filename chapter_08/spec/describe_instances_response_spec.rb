describe "parsing" do
  before(:all) do
    @describe_instances_response = 
      DescribeInstancesResponse.parse(RESPONSE_XML)
  end
  
  it "has collection of reservation sets" do
    @describe_instances_response.reservation_sets.should_not be_nil
  end

  describe "reservation set" do
    before(:all) do
      @reservation_set = @describe_instances_response.reservation_sets.first
    end
    
    it "has the security group" do
      @reservation_set.security_group.should == "default"
    end
    
    it "has a reservation id" do
      @reservation_set.reservation_id.should == "r-44a5402d"
    end
    
    it "it contains a collection of instances" do
      @reservation_set.instances.should_not be_nil
    end
    
    describe "instance" do
      before(:all) do
        @instance = @reservation_set.instances.first
      end
      
      it "has an instance id" do
        @instance.id.should == "i-28a64341"
      end
      
      it "has an image id" do
        @instance.image_id.should == "ami-6ea54007"
      end
      
      it "has an instance state" do
        @instance.state.should == "running"
      end
      
      it "has a private dns name" do
        @instance.private_dns_name.should == "10-251-50-132.ec2.internal"
      end
      
      it "has a dns name" do
        @instance.dns_name.should == "ec2-72-44-33-4.compute-1.amazonaws.com"
      end
      
      it "has a key name" do
        @instance.key_name.should == "example-key-name"
      end
      
      it "has an instance type" do
        @instance.type.should == "m1.large"
      end
      
      it "has a launch time" do
        @instance.launch_time.should == "2007-08-07T11:54:42.000Z"
      end
    end
  end
end
