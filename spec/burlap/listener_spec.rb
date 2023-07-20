require "spec_helper"

RSpec.describe Burlap::Listener do
  describe ".parse" do
    subject(:result) { Burlap.parse(reply) }

    context "when response is no such method" do
      let(:reply) { File.read("spec/data/no_such_method.burlap") }

      before { raise if reply.nil? }

      it "parses successfully" do
        expect(result).to be_a_kind_of(OpenStruct)
        expect(result.code).to eq("NoSuchMethodException")
        expect(result.message).to eq("The service has no method named: getUserID")
      end
    end

    describe "when response is record not found" do
      let(:reply) { File.read("spec/data/record_not_found.burlap") }

      before { raise if reply.nil? }

      it "parses successfully" do
        expect(result).to be_a_kind_of(Burlap::Fault)
        expect(result.code).to eq("ServiceException")
        expect(result.message).to eq("No row with the given identifier exists: [com.sapienter.jbilling.server.user.db.UserDTO#21]")
      end
    end
  end
end
