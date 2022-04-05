require "file_utils"
require "spec"

module Sponsors
  macro create_configs(random)
    SAMPLE_CONFIGS = [] of String
      {% for i in 0..5 %}
      SAMPLE_CONFIGS << <<-JSON
      {
        "contact": {
          "twitter": "GeopJr1312"
        },
        "records": {
          "CNAME": [
            {
              "name": "#{{{random}}.sample}",
              "target": "#{{{random}}.sample}#{{{random}}.sample}.dev",
              "description": "Personal website"
            }
          ],
          "A": [
            {
              "name": "queer.software",
              "target": "#{Random.new.rand(101)}.#{Random.new.rand(10)}.#{Random.new.rand(10)}.#{Random.new.rand(10)}",
              "description": "Rewrite rule"
            },
            {
              "name": "wwww",
              "target": "29df:8f82:2533:d51e:724a:ade1:f0d3:48cb",
              "description": "Rewrite rule"
            }
          ]
        }
      }
      JSON
      {% end %}
  end

  create_configs(["Amy", "Watson", "Kate", "Baker", "Miley", "Tucker", "Evelyn", "Ferguson", "Grace", "Robinson", "Alina", "Rogers", "Tara", "Murphy", "Luke", "Ross", "Steven", "Elliott", "Kristian", "Crawford", "April", "Crawford", "Miranda", "Kelly", "James", "Sullivan", "Daryl", "Taylor", "Preston", "Watson", "Agata", "Miller", "Spike", "Howard", "Sabrina", "Williams", "Alexia", "Adams", "Ned", "Myers", "Kevin", "Alexander", "Aida", "Grant", "George", "Hawkins", "Lucia", "Reed", "Edith", "Parker", "Spike", "Riley", "Reid", "Tucker", "Bruce", "Murphy", "Charlotte", "Smith", "Adam", "Crawford", "Olivia", "Clark", "Sarah", "Richards", "Ned", "Edwards", "Lana", "Howard", "Wilson", "Mitchell", "Alberta", "Alexander", "Andrew", "Carter", "Lucy", "Howard", "Lucia", "Roberts", "Edwin", "Payne", "Tess", "Riley", "Oliver", "Allen", "Kimberly", "Martin", "Henry", "Ferguson", "Maximilian", "Andrews", "Edgar", "Higgins", "Rubie", "West", "Sienna", "Baker", "Rafael", "Hunt", "Carl", "Crawford", "Dale", "Robinson", "Fenton", "Roberts", "Kristian", "Howard", "Luke", "Scott", "Carl", "Parker", "Steven", "Ryan", "Albert", "Sullivan", "Chloe", "Thompson", "Dainton", "Davis", "Tyler", "Fowler", "Michael", "Bailey", "Aldus", "Walker", "Owen", "Crawford", "Rosie", "Hall", "Bruce", "Foster", "Kelvin", "Elliott", "Frederick", "Farrell", "Jenna", "Evans", "James", "Morris", "Hailey", "Perry", "Frederick", "Alexander", "Ryan", "Foster", "Maximilian", "Mitchell", "Arianna", "Murphy", "Adrianna", "Morgan", "Hailey", "Mitchell", "Alan", "Miller", "Cherry", "Roberts", "Reid", "Walker", "Alfred", "Thompson", "Carina", "Nelson", "Ryan", "Jones", "Jasmine", "Harris", "Wilson", "Elliott", "Adrianna", "Thomas", "Miller", "Adams", "Alexander", "Richards", "John", "Stewart", "Byron", "Campbell", "Adison", "Nelson", "Emily", "Ellis", "Bruce", "Bennett", "Rebecca", "Barrett", "Kelvin", "Warren", "Adam", "Owens", "Michael", "Wells", "Arthur", "Fowler", "Rubie", "Davis", "Catherine", "Mason", "Eleanor", "Riley"])

  SPEC_FOLDER = Path[Dir.tempdir, "sponsors_spec"]
  FileUtils.rm_rf(SPEC_FOLDER)

  DOMAINS        = SPEC_FOLDER.join("domains")
  GEOPJR_DEV     = DOMAINS.join("geopjr.dev")
  QUEER_SOFTWARE = DOMAINS.join("queer.software")

  Dir.mkdir_p(GEOPJR_DEV)
  Dir.mkdir_p(QUEER_SOFTWARE)

  SAMPLE_CONFIGS.each do |domain|
    File.write(GEOPJR_DEV.join("#{Random.new.rand(1312)}.json"), domain)
    File.write(QUEER_SOFTWARE.join("#{Random.new.rand(1312)}.json"), domain)
  end

  Args = {
    "input"     => SPEC_FOLDER,
    "type"      => Sponsors::Export::Format::PLAIN,
    "output"    => true,
    "overwrite" => true,
  }
end

def create_export_entries : Hash(String, Sponsors::Export)
  entries = Sponsors::Finder.find
  exports = Hash(String, Sponsors::Export).new
  entries.each do |k, v|
    tmp = [] of Sponsors::Record
    v.each do |dom|
      dom.json.records.each do |x, y|
        y.each do |z|
          tmp << Sponsors::Record.new(type: Sponsors::Record::Type.parse(x), name: z.name, target: z.target, comments: z.description)
        end
      end
    end
    exports[k] = Sponsors::Export.new(tmp)
  end
  exports
end

require "../src/sponsors"
