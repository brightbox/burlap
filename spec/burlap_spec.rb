require "spec_helper"

describe Burlap do

  it { Burlap.should respond_to(:resolver) }
  it { Burlap.should respond_to(:resolver=) }

  describe ".resolver" do
    it "should default to an instance of DefaultResolver" do
      Burlap.resolver.should be_a_kind_of(Burlap::DefaultResolver)
    end
  end

  describe ".parse" do
    it "should be specced"

    context "when emoji in response" do
      context "with UTF-8 encoded burlap" do
        let(:body) { "<burlap:reply><map><type></type><string>emoji</string><string>\u{1F33B}</string></map></burlap:reply>".force_encoding(Encoding::UTF_8) }

        it do
          expect(Burlap.parse(body)).to eq(Burlap::Hash["emoji" => "\u{1F33B}"])
        end
      end

      context "with ISO-8859-1 encoded burlap" do
        let(:body) { "<burlap:reply><map><type></type><string>emoji</string><string>\xED\xA0\xBC</string></map></burlap:reply>".force_encoding(Encoding::ISO_8859_1) }

        it do
          expect(Burlap.parse(body)).to eq(Burlap::Hash["emoji" => "í ¼"])
        end
      end
    end
  end

  describe ".dump" do
    it "should be specced"
  end
end
