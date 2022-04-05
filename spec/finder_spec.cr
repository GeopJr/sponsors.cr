require "./spec_helper"

describe Sponsors::Finder do
  it "finds and parses domain entries" do
    finds = Sponsors::Finder.find
    finds["geopjr.dev"].size.should eq(finds["queer.software"].size)
    finds["geopjr.dev"].size.should be > 0
  end
end
