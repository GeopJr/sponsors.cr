{% skip_file if @top_level.has_constant? "Spec" %}

require "option_parser"
require "./*"

module Sponsors
  formats = Sponsors::Export::Format.names.join(", ")
  dir = Dir.current

  # CLI global state used by classes & methods
  Args = {
    "input"     => Path.new,
    "type"      => Sponsors::Export::Format::TABLE,
    "output"    => false,
    "overwrite" => false,
  }

  parser = OptionParser.new do |parser|
    parser.banner = <<-BANNER
    #{"sponsors v#{Version}".colorize(:light_yellow)}
    
    #{"USAGE:".colorize(:light_yellow)}
        sponsors -i <DIRECTORY> -t <TYPE> [FLAGS]
    
    #{"FLAGS:".colorize(:light_yellow)}
    BANNER
    parser.on("-i DIRECTORY", "--input=DIRECTORY", "Input directory to look for json files in - Default: .") do |input|
      dir = input
      Sponsors::Logger.fatal("Directory \"#{dir}\" does not exist") unless Dir.exists?(dir)
    end
    parser.on("-t TYPE", "--type=TYPE", "The output type (#{formats}) - Default: TABLE") do |input|
      type = Sponsors::Export::Format.parse?(input)
      Sponsors::Logger.fatal("Unknown type \"#{input}\", available: \"#{formats}\"") if type.nil?
      Args["type"] = type
    end
    parser.on("-o DIRECTORY", "--output=DIRECTORY", "Write to files in DIRECTORY - Default: STDOUT") do |input|
      output = input
      Sponsors::Logger.fatal("Directory \"#{input}\" does not exist") unless Dir.exists?("#{output}")
      Args["output"] = Path[output].expand
    end
    parser.on("-r", "--overwrite", "Overwrite if files already exist - Default: false") do
      Args["overwrite"] = true
    end
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    {% for option in ["invalid_option", "missing_option"] %}
    parser.{{option.id}} do |option|
      Sponsors::Logger.error("{{option.gsub(/_/, " ").capitalize.id}} \"#{option}\"")
      puts parser
      exit(1)
    end
    {% end %}
  end

  parser.parse

  Args["input"] = Path[dir].expand
end
