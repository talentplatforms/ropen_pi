# frozen_string_literal: true

require 'json-schema'

module RopenPi
  module Specs
    class ExtendedTypeAttribute < JSON::Schema::TypeV4Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        schema_nullable = (current_schema.schema['nullable'] == true || current_schema.schema['x-nullable'] == true)

        return if data.nil? && schema_nullable

        super
      end
    end

    class ExtendedSchema < JSON::Schema::Draft4
      def initialize
        super

        @attributes['type'] = ExtendedTypeAttribute
        temp_uri = 'http://tempuri.org/rswag/specs/extended_schema'
        @uri = URI.parse(temp_uri)
        @names = [temp_uri]
      end
    end

    JSON::Validator.register_validator(ExtendedSchema.new)
  end
end

