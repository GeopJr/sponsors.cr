module Sponsors
  # Responsible for serializing
  class Parse
    # A DNS record
    struct Record
      include JSON::Serializable

      # The subdomain
      property name : String
      # The target/ip it points to
      property target : String
      # Some comments on the record (if any)
      property description : String?
    end

    # A Domain structure
    struct Domain
      include JSON::Serializable

      # Contact info { PLATFORM => HANDLE }
      property contact : Hash(String, String)
      # DNS records { TYPE => `Record` }
      property records : Hash(String, Array(Record))
    end

    @json : Domain

    # JSON body String
    def initialize(body : String)
      @json = begin
        Domain.from_json(body)
      rescue
        Sponsors::Logger.fatal("One or more JSONs are not parsable, aborted.")
      end
    end

    # The json
    def json
      @json
    end
  end
end
