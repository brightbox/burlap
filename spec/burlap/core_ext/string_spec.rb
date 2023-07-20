require "spec_helper"

RSpec.describe String do
  describe "#to_burlap" do
    subject(:burlap) { input_string.to_burlap }

    context "with normal string" do
      let(:input_string) { "some string" }

      it "returns a string" do
        expect(burlap).to be_a_kind_of(described_class)
      end

      it "is correct" do
        expect(burlap).to eq("<string>some string</string>")
      end
    end

    context "with html unsafe content" do
      let(:input_string) { "<script type='text/js'>hello</script>" }

      it "returns escaped html" do
        expect(burlap).to match(%r{&lt;script type='text/js'&gt;hello&lt;/script&gt;})
      end
    end
  end
end
