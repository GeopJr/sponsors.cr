require "./spec_helper"

describe Sponsors::Export do
  it "exports as plain format" do
    exports = create_export_entries
    find = Sponsors::Finder.find
    exports.each do |k, v|
      random_find_records = find.values.sample.sample.json.records
      random_find_key = random_find_records.keys.sample
      random_find_value = random_find_records[random_find_key].sample
      formatted_record = "#{random_find_key} ~ #{random_find_value.name} ~ #{random_find_value.content} ~ 1 ~ #{random_find_value.description}"
      v.export.split("\n").should contain(formatted_record)
    end
  end

  it "exports as table format" do
    exports = create_export_entries
    find = Sponsors::Finder.find
    exports.each do |k, v|
      random_find_records = find.values.sample.sample.json.records
      random_find_key = random_find_records.keys.sample
      random_find_value = random_find_records[random_find_key].sample
      formatted_record = [random_find_key, random_find_value.name, random_find_value.content, "1", random_find_value.description]
      formatted_record.each do |r|
        v.export(:TABLE).split("|").map { |x| x.strip }.reject! { |x| x.empty? }.compact!.should contain(r)
      end
    end
  end

  it "exports as json format" do
    exports = create_export_entries
    find = Sponsors::Finder.find
    exports.each do |k, v|
      random_find_records = find.values.sample.sample.json.records
      random_find_key = random_find_records.keys.sample
      random_find_value = random_find_records[random_find_key].sample
      values = ["1", random_find_value.content, random_find_key, random_find_value.name]
      found = Hash(String, JSON::Any).new
      JSON.parse(v.export(:JSON)).as_h["records"].as_a.each do |z|
        y = z.as_h.values.map { |x| x.to_s }
        i = 0
        values.each do |x|
          i = i.succ if y.includes?(x)
        end
        found = z.as_h if i == values.size
      end
      found.keys.size.should be > 0
      found.each do |x, y|
        if x == "ttl"
          y.as_i.should eq(1)
        elsif x == "content"
          y.to_s.should eq(random_find_value.content)
        elsif x == "type"
          y.to_s.should eq(random_find_key)
        else
          y.to_s.should eq(random_find_value.name)
        end
      end
    end
  end

  it "exports as hjson format" do
    exports = create_export_entries
    find = Sponsors::Finder.find
    exports.each do |k, v|
      random_find_records = find.values.sample.sample.json.records
      random_find_key = random_find_records.keys.sample
      random_find_value = random_find_records[random_find_key].sample
      v.export(:HJSON).should contain("#{random_find_value.description}")
    end
  end
end
