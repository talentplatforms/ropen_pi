# helper for the open api documentation
module RopenPi
  module ConfigHelper
    #
    def self.date_param(name, desc: 'tba')
      param(name, :string, fmt: 'date-time', desc: desc)
    end

    def self.uuid_param(name, desc: 'tba')
      param(name, :string, fmt: 'uuid', desc: desc)
    end

    def self.string_param(name, desc: 'tba')
      param(name, :string, desc: desc)
    end

    def self.int_param(name, desc: 'tba')
      param(name, :integer, desc: desc)
    end

    def self.bool_param(name, desc: 'tba')
      param(name, :boolean, desc: desc)
    end

    def self.ref_param(name, ref, desc: 'tba')
      param(name, 'null', desc: desc).merge(schema: { '$ref': ref })
    end

    def self.param_in_path(name, schema_type, fmt: nil, desc: 'tba')
      param(name, schema_type, fmt: fmt, desc: desc).merge(
        in: :path,
        required: true
      )
    end

    def self.param(name, schema_type, fmt: nil, desc: 'tba')
      {
        name: name.to_s,
        description: desc,
        in: :query,
        schema: schema(schema_type, fmt: fmt)
      }
    end

    def self.schema(type, fmt: nil)
      {}.tap do |schema|
        schema[:type] = type
        schema[:format] = fmt if fmt.present?
      end
    end

    def self.schema_enum(values, type: :string)
      {
        type: type,
        enum: values
      }
    end

    #

    def self.collection_response_type(ref, desc: 'tba')
      {
        description: desc,
        type: :object,
        properties: {
          data: { type: :array, items: { '$ref': ref } }
        }
      }
    end

    def self.response_type(ref, desc: 'tba')
      {
        description: desc,
        type: :object,
        properties: { data: { '$ref': ref } }
      }
    end
  end
end
