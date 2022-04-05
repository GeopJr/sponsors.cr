require "./spec_helper"

describe Sponsors::Record do
  it "creates a dns record" do
    data = {type: Sponsors::Record::Type::CNAME, name: "collision", target: "github.io", ttl: 1312, comments: "Collision's website", priority: nil}
    dns_record = Sponsors::Record.new(data[:type], data[:name], data[:target], data[:ttl], data[:comments])
    dns_record.to_named_tuple.should eq(data)
  end
end
