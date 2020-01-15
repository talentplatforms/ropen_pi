# helper for the open api documentation
module RopenPi
  module Param
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
  end

  module Type
    def self.date_time_type(opts)
      string_type(opts).merge(format: 'date-time')
    end

    def self.uuid_type(opts)
      string_type(opts).merge(format: 'uuid')
    end

    def self.string_type(opts)
      type('string', opts)
    end

    def self.integer_type(opts)
      type('integer', opts)
    end

    def self.type(thing, opts)
      { type: thing }.merge(opts)
    end

    def self.string_array_type(opts)
      { type: 'array', items: 'string' }
    end

    def self.ref_type(ref)
      { '$ref': ref }
    end
  end

  module Response
    def self.collection(ref, desc: 'tba', type: 'application/json')
      {
        description: desc,
        content: {
          type => {
            data: { type: :array, items: { '$ref': ref } }
          }
        }
      }
    end

    def self.single(ref, desc: 'tba', type: 'application/json')
      {
        description: desc,
        content: {
          type => {
            data: { '$ref': ref }
          }
        }
      }
    end
  end
end
