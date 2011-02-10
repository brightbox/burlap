require "spec_helper"

describe Burlap::Error do
  it "should inherit from standard error" do
    Burlap::Error.ancestors.should include(StandardError)
  end
end
