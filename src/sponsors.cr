require "json"
{% if @top_level.has_constant? "Spec" %}
  require "./sponsors/*"
{% else %}
  require "./sponsors/cli"
{% end %}

module Sponsors
  # CLI version from shard.yml
  Version = {{read_file("./shard.yml").split("version: ")[1].split("\n")[0]}}

  {% if !@top_level.has_constant? "Spec" %}
    entries = Sponsors::Finder.find
    exports = Hash(String, Sponsors::Export).new
    entries.each do |k, v|
      tmp = [] of Sponsors::Record
      v.each do |dom|
        dom.json.records.each do |x, y|
          y.each do |z|
            tmp << Sponsors::Record.new(type: Sponsors::Record::Type.parse(x), name: z.name, target: z.target, comments: z.description, priority: z.priority)
          end
        end
      end
      exports[k] = Sponsors::Export.new(tmp)
    end
    # puts exports
    if Args["output"]
      extension = [Sponsors::Export::Format::TABLE, Sponsors::Export::Format::PLAIN].includes?(Args["type"]) ? "md" : Args["type"].to_s.downcase
      exports.keys.each do |k|
        filepath = Args["output"].as(Path).join("#{k}.#{extension}")
        Sponsors::Logger.fatal("File \"#{filepath}\" already exists.") if File.exists?(filepath) && !Args["overwrite"]
      end
      exports.each do |k, v|
        filepath = Args["output"].as(Path).join("#{k}.#{extension}")
        File.write(filepath, v.export)
      end
    else
      exports.each do |k, v|
        Sponsors::Logger.status(k)
        STDOUT.puts(v.export)
      end
    end
  {% end %}
end
