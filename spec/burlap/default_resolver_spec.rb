require "spec_helper"

describe Burlap::DefaultResolver do

  describe "#mappings" do
    before { @resolver = Burlap::DefaultResolver.new }
    it "should default to a hash" do
      @resolver.mappings.should == {}
    end
    it "should raise an error if name is passed with no block" do
      lambda do
        @resolver.mappings "thing"
      end.should raise_error(ArgumentError, "block is required when name is given")
    end
    it "should store a single mapping when passed a name and block" do
      @resolver.mappings["thing"].should == nil

      @resolver.mappings "thing" do
        "thing's block"
      end

      @result = @resolver.mappings["thing"]
      @result.should_not == nil
      @result.should be_a_kind_of(Proc)
      @result.call.should == "thing's block"
    end
    it "should store the same block against multiple mappings when passed more than one name at once" do
      @resolver.mappings "black", "white" do
        # Mixing black and white keys. Geddit?
        # John Agard does, http://www.intermix.org.uk/poetry/poetry_01_agard.asp
        "half-caste symphony"
      end

      %w(black white).each do |key|
        result = @resolver.mappings[key]
        result.should_not == nil
        result.should respond_to(:call)
        result.call.should == "half-caste symphony"
      end
    end
    it "should use the last argument if it responds to #call in place of a block"
  end

  describe "parsing default tags" do
    before(:all) do
      @resolver = Burlap.resolver
    end

    [
      {:name => "int", :burlap => "15", :expected => 15},
      {:name => "double", :burlap => "1.5", :expected => 1.5},
      {:name => "string", :burlap => "some string value", :expected => "some string value"},
      {:name => "null", :burlap => "", :expected => nil}
    ].each do |tag|
      describe tag[:name] do
        it "should be parsed into ruby" do
          burlap_tag = Burlap::BaseTag.new(:name => tag[:name], :value => tag[:burlap])
          @resolver.convert_to_native(burlap_tag).should == tag[:expected]
        end
      end
    end

    describe "boolean" do
      it "should parse true" do
        true_tag = Burlap::BaseTag.new(:name => "boolean", :value => "1")
        @resolver.convert_to_native(true_tag).should == true
      end
      it "should parse false" do
        false_tag = Burlap::BaseTag.new(:name => "boolean", :value => "0")
        @resolver.convert_to_native(false_tag).should == false
      end
    end

    describe "list" do
      it "should parse an empty array" do
        arr = Burlap.parse "<list><type>[java.lang.Integer</type><length>0</length></list>"

        arr.should == []
      end
      it "should parse an array containing one string" do
        arr = Burlap.parse "<list><type>[string</type><length>1</length><string>1</string></list>"

        arr.should == ["1"]
      end
      it "should parse an array with multiple elements" do
        arr = Burlap.parse %{<list><type></type><length>3</length><int>0</int><double>1.3</double><string>foobar</string></list>}

        arr.should == [0, 1.3, "foobar"]
      end
    end

  end

end
