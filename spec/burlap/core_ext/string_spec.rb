require "spec_helper"

describe String do
  describe "#to_burlap" do
    before do
      @result = "some string".to_burlap
    end
    it "should return a string" do
      @result.should be_a_kind_of(String)
    end
    it "should be correct" do
      @result.should == "<string>some string</string>"
    end
  end

  context "for html unsafe content" do
    before do
      @result = "<script type='text/js'>hello</script>".to_burlap
    end

    it "should return escaped html" do
      @result.should =~ /&lt;script type='text\/js'&gt;hello&lt;\/script&gt;/
    end
  end
end
