# Responsible for finding the domain files
module Sponsors::Finder
  extend self

  # Recursively searches all files in input for .jsons, parses them and returns them in the format of:
  #
  # { DOMAIN => Array(`Sponsors::Parse`)}
  def find(path : Path = Sponsors::Args["input"].as(Path)) : Hash(String, Array(Sponsors::Parse))
    res = Hash(String, Array(Sponsors::Parse)).new
    Dir.open(path).each_child do |child|
      new_path = path.join(child)
      if Dir.exists?(new_path)
        res.merge!(find(new_path))
      elsif File.exists?(new_path) && new_path.extension.downcase == ".json"
        begin
          parsed = Sponsors::Parse.new(File.read(new_path))
          if res.has_key?(new_path.parent.basename)
            res[new_path.parent.basename] << parsed
          else
            res[new_path.parent.basename] = [parsed]
          end
        end
      end
    end
    return res
  end
end
