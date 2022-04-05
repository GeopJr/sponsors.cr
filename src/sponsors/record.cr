module Sponsors
  # A DNS record
  class Record
    # The DNS type
    enum Type
      A
      AAAA
      CNAME
      TXT
    end

    # [MACRO] Generate the class and its return types
    macro create_class(params)
        def initialize({{params.map { |k, v| "#{k} : #{v["type"].id}" }.join(", ").id}})
          {% for type in params.keys %}
              @{{type.id}} = {{type.id}}
          {% end %}
        end

        {% for type, value in params %}
            # {{value["doc"].id}}
            def {{type.id}} : {{value["type"].gsub(/ ?=.+/, "").id}}
                @{{type.id}}
            end
        {% end %}
        
        # Turn the record into a NamedTuple
        def to_named_tuple : NamedTuple({{params.map { |k, v| "#{k}: #{v["type"].gsub(/ ?=.+/, "").id}".id }.join(", ").id}})
            {
            {% for type, value in params %}
                {{type.id}}: @{{type.id}},
            {% end %}
            }
        end

        # Turn the record into a Hash
        def to_h : Hash(Symbol, {{params.values.map { |v| v["type"].gsub(/ ?=.+/, "").gsub(/\?/, " | Nil") }.join(" | ").split(" | ").uniq.map { |x| x.id }.join(" | ").id}})
            self.to_named_tuple.to_h
        end
    end

    create_class({
      type:     {type: "Type", doc: "The DNS record type"},
      name:     {type: "String", doc: "The subdomain"},
      target:   {type: "String", doc: "The target/ip it points to"},
      ttl:      {type: "Int32 = 14400", doc: "TTL (default: 14400)"},
      comments: {type: "String? = nil", doc: "Comments on the record"},
    })
  end
end
