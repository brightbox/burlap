require "spec_helper"

describe Burlap::Hash do

  it "should inherit from ordered hash" do
    Burlap::Hash.ancestors.should include(ActiveSupport::OrderedHash)
  end

  it { should respond_to(:__type__) }
  it { should respond_to(:__type__=) }

  describe "#__type__" do
    it "should default to an empty string" do
      Burlap::Hash.new.__type__.should == ""
    end
  end

  describe "#[]" do
    it "should be compatible with Hash#[]" do
      bhash = Burlap::Hash["one" => "two", "three" => "four"]

      bhash.keys.should =~ ["one", "three"]
      bhash.values.should =~ ["two", "four"]
    end
    it "should accept a second string argument to set __type__ directly" do
      [{}, {:some => "options"}, {:some => "options", :__type__ => "is ignored"}].each do |h|
        bhash = Burlap::Hash[{}, "com.java.hashmap"]
        bhash.__type__.should == "com.java.hashmap"
      end
    end
  end

  describe "#inspect" do
    before :all do
      @h = Burlap::Hash[[["one", "two"], [:three, 4]], "Fred"]
    end
    it "should not contain OrderedHash" do
      @h.inspect.should_not include("OrderedHash")
    end
    it "should start with Burlap::Hash" do
      @h.inspect.should =~ /#<Burlap::Hash/
    end
    it "should contain the hash, inspected" do
      @h.inspect.should include(%({"one"=>"two", :three=>4}))
    end
    it "should contain the type, inspected" do
      @h.inspect.should include(%Q{__type__="Fred"})
    end
  end

  describe "#to_burlap" do
    describe "wrapping a string" do
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
    describe "wrapping multiple keys" do
      before :all do
        @bd = Burlap::Hash[[["name", "caius durling"], ["age", 101]], "burlap.user"]
        @result = @bd.to_burlap
        @doc = Nokogiri::XML(@result)
      end
      it "should return a string" do
        @result.should be_a_kind_of(String)
      end
      it "should have a map root" do
        element_exists_with :selector => "map", :count => 1
      end
      it "should have a type element" do
        @result.should =~ %r{<type>burlap.user</type>}
      end
      it "should have a name keypair" do
        @result.should =~ %r{<string>name</string><string>caius durling</string>}
      end
      it "should have an age keypair" do
        @result.should =~ %r{<string>age</string><int>101</int>}
      end
    end
    describe "wrapping nested keys" do
      before do
        # Effectively {"people" => [{"name" => "caius durling", "age" => 101}]}
        @bd = Burlap::Hash[[
          ["people", {"name" => "caius durling", "age" => 101}]
        ], "burlap-peoples"]
        @result = @bd.to_burlap
        # <map><type></type><string>people</string><map><type></type><string>name</string><string>caius durling</string><string>age</string><int>101</int></map></map>
      end
      it "should return a string" do
        @result.should be_a_kind_of(String)
      end
      it "should be generated properly, including nested elements" do
        xml_string = <<-EOF
          <map>
            <type>burlap-peoples</type>

            <string>people</string>
            <map>
              <type></type>

              <string>name</string>
              <string>caius durling</string>

              <string>age</string>
              <int>101</int>
            </map>

          </map>
        EOF
        xml_string.gsub!(/(^|\n)\s*/m, "")
        @result.should == xml_string
      end
    end
  end

end
