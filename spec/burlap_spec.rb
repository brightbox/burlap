require "spec_helper"

RSpec.describe Burlap do
  it { is_expected.to respond_to(:resolver) }
  it { is_expected.to respond_to(:resolver=) }

  describe ".resolver" do
    it "defaults to an instance of DefaultResolver" do
      expect(described_class.resolver).to be_a_kind_of(Burlap::DefaultResolver)
    end
  end

  describe ".parse" do
    context "when emoji in response" do
      context "with ASCII 8BIT encoded burlap" do
        let(:body) { "<burlap:reply><map><type></type><string>emoji</string><string>\xED\xA0\xBC</string></map></burlap:reply>".force_encoding(encoding) }
        let(:encoding) { Encoding::ASCII_8BIT }

        it do
          expect(described_class.parse(body)).to be_nil
        end

        it do
          expect { described_class.parse(body, true) }.to raise_error(Encoding::UndefinedConversionError)
        end
      end

      context "with UTF-8 encoded burlap" do
        let(:body) { "<burlap:reply><map><type></type><string>emoji</string><string>\u{1F33B}</string></map></burlap:reply>".force_encoding(encoding) }
        let(:encoding) { Encoding::UTF_8 }

        it do
          expect(described_class.parse(body)).to eq(Burlap::Hash["emoji" => "\u{1F33B}"])
        end

        it do
          expect(described_class.parse(body, true)).to eq(Burlap::Hash["emoji" => "\u{1F33B}"])
        end
      end

      context "with ISO-8859-1 encoded burlap" do
        let(:body) { "<burlap:reply><map><type></type><string>emoji</string><string>\xED\xA0\xBC</string></map></burlap:reply>".force_encoding(encoding) }
        let(:encoding) { Encoding::ISO_8859_1 }

        it do
          expect(described_class.parse(body)).to be_nil
        end

        it do
          expect(described_class.parse(body, true)).to eq(Burlap::Hash["emoji" => "í ¼"])
        end
      end
    end
  end
end
