require "spec_helper"

describe Burlap::Call do

  before do
    @valid_params = {:method => "updateUser"}
  end

  describe "#headers" do
    it "should default to an array" do
      Burlap::Call.new(@valid_params).headers.should == {}
    end
  end

  describe "#arguments" do
    it "should default to a hash" do
      Burlap::Call.new(@valid_params).arguments.should == []
    end
  end

  describe "#method" do
    it "should be required" do
      lambda { Burlap::Call.new(@valid_params.except(:method)) }.should raise_error(ArgumentError, "method is required")
    end
  end

  describe "#to_burlap" do
    before(:all) { Timecop.freeze(Time.local(2010, 9, 11, 10, 0, 0)) }
    after(:all)  { Timecop.return }
    describe "single dimensional" do
      before :all do
        @call = Burlap::Call.new(:method => "updateUser", :arguments => ["one", 2, 3.0, nil, true, Time.now])
        @response = @call.to_burlap
      end
      it "should have a burlap:call root" do
        @response.should =~ /\A<burlap:call>/
        @response.should =~ %r{</burlap:call>\z}
      end
      it "should have a method element" do
        @response.should =~ %r{<method>updateUser</method>}
      end
      it "should have a string argument element" do
        @response.should =~ %r{<string>one</string>}
      end
      it "should have an int argument element" do
        @response.should =~ %r{<int>2</int>}
      end
      it "should have a double argument element" do
        @response.should =~ %r{<double>3.0</double>}
      end
      it "should have a null argument element" do
        @response.should =~ %r{<null></null>}
      end
      it "should have a boolean argument element" do
        @response.should =~ %r{<boolean>1</boolean>}
      end
      it "should have a date argument element" do
        @response.should =~ %r{<date>#{Regexp.escape(Time.now.iso8601(3))}</date>}
      end
      describe "headers" do
        it "should generate header key/values"
      end
    end
    describe "multi-dimensional" do
      before :all do
        contact = Burlap::Hash[[
          ["number", 101],
          ["street", "auckland road"],
          ["town", "elizabethtown"],
          ["country", "finland"],
          ["foreign", true]
        ], "burlap.user"]
        @call = Burlap::Call.new(:method => "updateUser", :arguments => ["one", contact])
        @result = @call.to_burlap
      end
      it "should return a string" do
        @result.should be_a_kind_of(String)
      end
      it "should generate the right burlap" do
        # todo: add headers
        xml_string = <<-EOF
          <burlap:call>
            <method>updateUser</method>

            <string>one</string>

            <map>
              <type>burlap.user</type>

              <string>number</string>
              <int>101</int>

              <string>street</string>
              <string>auckland road</string>

              <string>town</string>
              <string>elizabethtown</string>

              <string>country</string>
              <string>finland</string>

              <string>foreign</string>
              <boolean>1</boolean>
            </map>

          </burlap:call>
        EOF
        xml_string.gsub!(/(^|\n)\s*/m, "")
        @result.should == xml_string
      end
    end
  end

end
