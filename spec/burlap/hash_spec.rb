require "spec_helper"

describe Burlap::Hash do

  it "should inherit from Hash" do
    Burlap::Hash.ancestors.should include(Hash)
  end

  it "should behave like a Hash"

  describe "#__type__" do
    it "should default to an empty string" do
      Burlap::Hash.new.__type__.should == ""
    end
  end

  it { should respond_to(:__type__=) }

  describe "#[]" do
    it "should be compatible with Hash#[]" do
      bhash = Burlap::Hash["one" => "two", "three" => "four"]
      bhash.should == Hash["one" => "two", "three" => "four"]
    end
    it "should accept a second string argument to set __type__ directly" do
      [{}, {:some => "options"}, {:some => "options", :__type__ => "is ignored"}].each do |h|
        bhash = Burlap::Hash[{}, "com.java.hashmap"]
        bhash.__type__.should == "com.java.hashmap"
      end
    end
  end

  describe "#to_burlap" do
    # <map>
    #   <type>org.ruby-lang.string</type>
    #   <string>value</string>
    #   <string>something</string>
    # </map>
    before(:all) do
      @bd = Burlap::Hash[{:value => "something"}, "org.ruby-lang.string"]
      @result = @bd.to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should have a map root" do
      @result.should =~ /^<map>/
      @result.should =~ %r{</map>$}
    end
    it "should have a nested type node" do
      @result.should =~ %r{<type>org.ruby-lang.string</type>}
    end
    it "should have nested value nodes" do
      @result.should =~ %r{<string>value</string>}
      @result.should =~ %r{<string>something</string>}
    end
  end

end
