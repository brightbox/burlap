require "spec_helper"

RSpec.describe Burlap::Error do
  it "inherits from standard error" do
    expect(described_class.ancestors).to include(StandardError)
  end
end
