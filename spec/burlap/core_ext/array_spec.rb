require "spec_helper"

RSpec.describe Array do
  describe "#to_burlap" do
    subject(:burlap) { array.to_burlap }

    context "with 0 elements" do
      let(:array) { [] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "has a list root" do
        expect(burlap).to match(/^<list>/)
        expect(burlap).to match(%r{</list>$})
      end

      it "has a type element" do
        expect(burlap).to match(%r{<type></type>})
      end

      it "has a length element" do
        expect(burlap).to match(%r{<length>#{array.size}</length>})
      end

      it "creates a Burlap::Array instance from itself and delegate #to_burlap to it" do
        mock_burlap_array = instance_double(Burlap::Array)
        expect(Burlap::Array).to receive(:[]).with(no_args).and_return(mock_burlap_array)
        expect(mock_burlap_array).to receive(:to_burlap).and_return("<burlap>array</burlap>")

        expect(array.to_burlap).to eq("<burlap>array</burlap>")
      end
    end

    context "with 1 element" do
      let(:array) { [:one] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "has a list root" do
        expect(burlap).to match(/^<list>/)
        expect(burlap).to match(%r{</list>$})
      end

      it "has a type element" do
        expect(burlap).to match(%r{<type></type>})
      end

      it "has a length element" do
        expect(burlap).to match(%r{<length>#{array.size}</length>})
      end

      it "creates a Burlap::Array instance from itself and delegate #to_burlap to it" do
        mock_burlap_array = instance_double(Burlap::Array)
        expect(Burlap::Array).to receive(:[]).with(*array).and_return(mock_burlap_array)
        expect(mock_burlap_array).to receive(:to_burlap).and_return("<burlap>array</burlap>")

        expect(array.to_burlap).to eq("<burlap>array</burlap>")
      end
    end

    context "with 2 elements" do
      let(:array) { [:one, "two"] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "has a list root" do
        expect(burlap).to match(/^<list>/)
        expect(burlap).to match(%r{</list>$})
      end

      it "has a type element" do
        expect(burlap).to match(%r{<type></type>})
      end

      it "has a length element" do
        expect(burlap).to match(%r{<length>#{array.size}</length>})
      end

      it "creates a Burlap::Array instance from itself and delegate #to_burlap to it" do
        mock_burlap_array = instance_double(Burlap::Array)
        expect(Burlap::Array).to receive(:[]).with(*array).and_return(mock_burlap_array)
        expect(mock_burlap_array).to receive(:to_burlap).and_return("<burlap>array</burlap>")

        expect(array.to_burlap).to eq("<burlap>array</burlap>")
      end
    end

    context "with 3 elements" do
      let(:array) { [:one, "two", 3] }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(String)
      end

      it "has a list root" do
        expect(burlap).to match(/^<list>/)
        expect(burlap).to match(%r{</list>$})
      end

      it "has a type element" do
        expect(burlap).to match(%r{<type></type>})
      end

      it "has a length element" do
        expect(burlap).to match(%r{<length>#{array.size}</length>})
      end

      it "creates a Burlap::Array instance from itself and delegate #to_burlap to it" do
        mock_burlap_array = instance_double(Burlap::Array)
        expect(Burlap::Array).to receive(:[]).with(*array).and_return(mock_burlap_array)
        expect(mock_burlap_array).to receive(:to_burlap).and_return("<burlap>array</burlap>")

        expect(array.to_burlap).to eq("<burlap>array</burlap>")
      end
    end
  end
end
