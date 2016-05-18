require File.expand_path("spec_helper", File.dirname(File.dirname(__FILE__)))

describe "h plugin" do 
  it "adds h method for html escaping" do
    app(:h) do |r|
      h("<form>") + h(:form)
    end

    body.must_equal '&lt;form&gt;form'
  end
end
