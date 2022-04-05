module Sponsors
  # Class responsible for exporting a list of `Sponsors::Record` to file or STDOUT
  class Export
    # Available export formats
    enum Format
      # Just JSON
      JSON
      # HJSON is a mix of JSON and YAML
      #
      # In our case, it's same as `JSON` but with comments
      HJSON
      # A PLAIN format that allows you to parse it manually
      #
      # TYPE ~ NAME ~ TARGET ~ TTL ~ COMMENTS
      PLAIN
      # A Markdown TABLE format
      TABLE
    end

    # Available targets
    private enum Target
      # String
      TARGET
      IPV4
      IPV6
    end

    # You can pass the return of other classes, take a look at the main file.
    def initialize(records : Array(Sponsors::Record))
      @records = records
    end

    # The records it got initialized with
    def records : Array(Sponsors::Record)
      @records
    end

    # If they accept IPs, try to detect them and return the type
    private def target_type(type : Sponsors::Record::Type, value : String) : String
      return Target::TARGET.to_s.downcase if type == Sponsors::Record::Type::CNAME
      return Target::IPV4.to_s.downcase if /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/ === value && type == Sponsors::Record::Type::A
      return Target::IPV6.to_s.downcase if /^[a-fA-F0-9:]+$/ === value && type == Sponsors::Record::Type::AAAA
      return "content" if type == Sponsors::Record::Type::TXT
      return "mailServer" if type == Sponsors::Record::Type::MX

      puts "[ERROR]: Target matching failed - #{type.to_s} # #{value}"
      exit(1)
    end

    # Method responsible for formatting & returning the output based on `Format`
    def export(format : Format = Sponsors::Args["type"]) : String
      formatted_record = Hash(String, Array(Hash(String, String | Int32 | Nil))).new
      formatted_record["records"] = [] of Hash(String, String | Int32 | Nil)
      records.each do |dns_record|
        target = target_type(dns_record.type, dns_record.target)
        formatted_record["records"] << {
          "type"     => dns_record.type.to_s,
          "name"     => dns_record.name,
          target     => dns_record.target,
          "ttl"      => dns_record.ttl,
          "comments" => dns_record.comments,
          "priority" => dns_record.priority,
        }
      end

      case format
      when Format::JSON
        formatted_record["records"].map { |x| x.reject!("comments", x["priority"] ? nil : "priority") }
        return formatted_record.to_pretty_json
      when Format::HJSON
        clean_json = formatted_record.dup
        clean_json["records"] = clean_json["records"].map { |x| x.reject("comments", x["priority"] ? nil : "priority") }
        json = clean_json.to_pretty_json
        formatted_record["records"].each do |dns_record|
          json = json.gsub(/("type": "#{dns_record["type"]}",\n)(      "name": "#{dns_record["name"]}",\n)/, "\\1      # Comment: #{dns_record["comments"]}\n\\2")
        end
        return json
      when Format::PLAIN
        result = [] of String
        formatted_record["records"].each do |dns_record|
          result << "#{dns_record["type"]} ~ #{dns_record["name"]} ~ #{dns_record.values[2]} ~ #{dns_record["ttl"]} ~ #{dns_record["comments"]}"
        end
        return result.join("\n")
      when Format::TABLE
        lengths = {
          "type"     => formatted_record["records"].max_by { |dns_record| dns_record["type"].to_s.size }["type"].to_s.size,
          "name"     => formatted_record["records"].max_by { |dns_record| dns_record["name"].to_s.size }["name"].to_s.size,
          "target"   => formatted_record["records"].max_by { |dns_record| dns_record.values[2].to_s.size }.values[2].to_s.size,
          "ttl"      => formatted_record["records"].max_by { |dns_record| dns_record["ttl"].to_s.size }["ttl"].to_s.size,
          "comments" => formatted_record["records"].max_by { |dns_record| dns_record["comments"].to_s.size }["comments"].to_s.size,
        }
        arr_length = lengths.map { |k, v| k.size > v ? k.size : v }
        result = [] of String
        result << "| #{"TYPE".center(arr_length[0])} | #{"NAME".center(arr_length[1])} | #{"TARGET".center(arr_length[2])} | #{"TTL".center(arr_length[3])} | #{"COMMENTS".center(arr_length[4])} |"
        result << "#{arr_length.map { |x| "| :#{"-" * (x - 2)}: " }.join}|"
        formatted_record["records"].each do |dns_record|
          result << "| #{dns_record["type"].to_s.center(arr_length[0])} | #{dns_record["name"].to_s.center(arr_length[1])} | #{dns_record.values[2].to_s.center(arr_length[2])} | #{dns_record["ttl"].to_s.center(arr_length[3])} | #{dns_record["comments"].to_s.center(arr_length[4])} |"
        end
        return result.join("\n")
      else
        Sponsors::Logger.fatal("Unknown format type \"#{format}\"")
      end
    end
  end
end
