require File.dirname(__FILE__) + "/../spec_helper.rb"

describe "entry" do
  describe "initializatioin" do
    it "can take a json string" do
      PauldixEntries::Entry.new('{"title": "asdf"}').title.should == "asdf"
    end
    
    it "can take a hash of attributes" do
      PauldixEntries::Entry.new({:title => "foo"}).title.should == "foo"
    end
  end
  
  describe "validations" do
    it "requires a title" do
      entry = PauldixEntries::Entry.new(:body => "asdf")
      entry.should_not be_valid
      entry.errors.should have_key(:title)
    end
    
    it "requires a published_time" do
      entry = PauldixEntries::Entry.new(:body => "asdf")
      entry.should_not be_valid
      entry.errors.should have_key(:published_time)      
    end
    
    it "should be valid" do
      en = PauldixEntries::Entry.new(:title => "foo", :published_time => Time.now).should be_valid
    end
  end
end
