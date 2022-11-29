# helper for the open api documentation
module RopenPi
  module Param
    #
    def self.date_param(name, desc: 'tba', opts: {})
      param(name, :string, fmt: 'date-time', desc: desc, opts: opts)
    end

    def self.uuid_param(name, desc: 'tba', opts: {})
      param(name, :string, fmt: 'uuid', desc: desc, opts: opts)
    end

    def self.string_param(name, desc: 'tba', opts: {})
      param(name, :string, desc: desc, opts: opts)
    end

    def self.int_param(name, desc: 'tba', opts: {})
      param(name, :integer, desc: desc, opts: opts)
    end

    def self.bool_param(name, desc: 'tba', opts: {})
      param(name, :boolean, desc: desc, opts: opts)
    end

    def self.ref_param(name, ref, desc: 'tba', opts: {})
      param(name, 'null', desc: desc, opts: opts).merge(schema: { '$ref': ref })
    end

    def self.param_in_path(name, schema_type, fmt: nil, desc: 'tba', opts: {})
      param(name, schema_type, fmt: fmt, desc: desc, opts: opts)
        .merge(
          in: 'path',
          required: true
        )
        .merge(opts)
    end

    def self.param_in_header(name, schema_type, fmt: nil, desc: 'tba', opts: {})
      param(name, schema_type, fmt: fmt, desc: desc, opts: opts)
        .merge(
          in: 'header',
          required: false
        )
        .merge(opts)
    end

    def self.param(name, schema_type, fmt: nil, desc: 'tba', opts: {})
      {
        name: name.to_s,
        description: desc,
        in: 'query',
        schema: schema(schema_type, fmt: fmt)
      }.merge(opts)
    end

    def self.schema(type, fmt: nil)
      {}.tap do |schema|
        schema[:type] = type.to_s
        schema[:format] = fmt.to_s if fmt.present?
      end
    end

    def self.schema_enum(values, type: :string)
      {
        type: type.to_s,
        enum: values
      }
    end

    class << self
      alias boolean_param bool_param
      alias integer_param int_param
    end
  end

  module Type
    def self.date_time_type(opts = { example: '2020-02-02' })
      string_type(opts).merge(format: 'date-time')
    end

    def self.email_type(opts = { example: 'han.solo@example.com' })
      string_type(opts).merge(format: 'email')
    end

    def self.uuid_type(opts = { example: Digest::UUID.uuid_v5(Digest::UUID::OID_NAMESPACE, 'abcd12-1234ab-abcdef123') })
      string_type(opts).merge(format: 'uuid')
    end

    def self.string_type(opts = { example: 'Example string' })
      type('string', opts)
    end

    def self.integer_type(opts = { example: 1 })
      type('integer', opts)
    end

    def self.bool_type(opts = { example: true })
      type('boolean', opts)
    end

    def self.type(thing, opts = {})
      { type: thing }.merge(opts)
    end

    def self.string_array_type(opts = {})
      {
        type: 'array',
        items: { type: 'string', example: 'Example string' }
      }.merge(opts)
    end

    def self.ref_type(ref)
      { '$ref': ref }
    end

    class << self
      alias boolean_type bool_type
      alias int_type integer_type
    end
  end

  module Response
    def self.collection(ref, desc: 'tba', type: RopenPi::APP_JSON)
      {
        description: desc,
        content: {
          type => {
            schema: {
              type: 'object',
              properties: { data: { type: :array, items: { '$ref': ref } } }
            }
          }
        }
      }
    end

    def self.single(ref, desc: 'tba', type: RopenPi::APP_JSON)
      {
        description: desc,
        content: {
          type => {
            schema: {
              type: 'object',
              properties: { data: { '$ref': ref } }
            }
          }
        }
      }
    end
  end
end
