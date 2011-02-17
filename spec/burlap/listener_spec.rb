require "spec_helper"

describe Burlap::Listener do
  it "should be specced"
  describe "no such method fault response" do
    it "should parse it out" do
      reply = "<burlap:reply><fault><string>code</string><string>NoSuchMethodException</string><string>message</string><string>The service has no method named: getUserID</string></fault></burlap:reply>"

      response = Burlap.parse(reply)
      response.should be_a_kind_of(OpenStruct)
      response.code.should == "NoSuchMethodException"
      response.message.should == "The service has no method named: getUserID"
    end
  end
  describe "record not found response" do
    it "should parse successfully" do
      reply = record_not_found_burlap
      reply.should_not == nil

      response = Burlap.parse(reply)
      response.should be_a_kind_of(OpenStruct)
      response.code.should == "ServiceException"
      response.message.should == "No row with the given identifier exists: [com.sapienter.jbilling.server.user.db.UserDTO#21]"
    end

    def record_not_found_burlap
      File.read("spec/data/record_not_found.burlap")
    end
  end
end
