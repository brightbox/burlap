require "spec_helper"

describe Array do
  describe "#to_burlap" do
    [
      [],
      [:one],
      [:one, "two"],
      [:one, "two", 3]
    ].each do |arr|
      describe "with #{arr.size} elements" do
        describe "generating string" do
          before do
            @burlap = arr.to_burlap
          end
          it "should return a string" do
            @burlap.should be_a_kind_of(String)
          end
          it "should have a list root" do
            @burlap.should =~ /^<list>/
            @burlap.should =~ %r{</list>$}
          end
          it "should have a type element" do
            @burlap.should =~ %r{<type></type>}
          end
          it "should have a length element" do
            @burlap.should =~ %r{<length>#{arr.size}</length>}
          end
        end
        it "should create a Burlap::Array instance from itself and delegate #to_burlap to it" do
          @array = arr

          mock_burlap_array = double(Burlap::Array)
          if @array.empty?
            Burlap::Array.should_receive(:[]).with(no_args).and_return(mock_burlap_array)
          else
            Burlap::Array.should_receive(:[]).with(*@array).and_return(mock_burlap_array)
          end

          mock_burlap_array.should_receive(:to_burlap).and_return("<burlap>array</burlap>")

          @array.to_burlap.should == "<burlap>array</burlap>"
        end
      end
    end
  end
end
