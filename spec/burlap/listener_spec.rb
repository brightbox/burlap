require "spec_helper"

describe Burlap::Listener do
  it "should be specced"
  describe "fault response" do
    it "should parse it out" do
      reply = "<burlap:reply><fault><string>code</string><string>NoSuchMethodException</string><string>message</string><string>The service has no method named: getUserID</string></fault></burlap:reply>"

      response = Burlap.parse(reply)
      response.should be_a_kind_of(OpenStruct)
      response.code.should == "NoSuchMethodException"
      response.message.should == "The service has no method named: getUserID"
    end
  end
end
