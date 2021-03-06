require "./spec_helper"

describe Sponsors::Parse do
  it "parses json" do
    file = Dir.children(Sponsors::GEOPJR_DEV)[0]
    body = File.read(Sponsors::GEOPJR_DEV.join(file))
    parser = Sponsors::Parse.new(body)
    JSON.parse(parser.json.to_json).should eq(JSON.parse(body))
  end
end
