  # frozen_string_literal: true

require 'active_support/core_ext/hash/slice'
require 'json-schema'
require 'json'
require 'ropen_pi/specs/extended_schema'

class RopenPi::Specs::ResponseValidator
  def initialize(config = ::RopenPi::Specs.config)
    @config = config
  end

  def validate!(metadata, response)
    open_api_doc = @config.get_doc(metadata[:doc])

    validate_code!(metadata, response)
    validate_headers!(metadata, response.headers)
    validate_body!(metadata, open_api_doc, response.body)
  end

  private

  def validate_code!(metadata, response)
    expected = metadata[:response][:code].to_s

    # rubocop:disable Style/GuardClause
    if response.code != expected
      raise RopenPi::Specs::UnexpectedResponse,
            "Expected response code '#{response.code}' to match '#{expected}'\n" \
            "Response body: #{response.body}"
    end
    # rubocop:enable Style/GuardClause
  end

  def validate_headers!(metadata, headers)
    expected = (metadata[:response][:headers] || {}).keys
    expected.each do |name|
      raise RopenPi::Specs::UnexpectedResponse, "Expected response header #{name} to be present" if headers[name.to_s].nil?
    end
  end

  def validate_body!(metadata, open_api_doc, body)
    test_schemas = extract_schemas(metadata)
    return if test_schemas.nil? || test_schemas.empty?

    components = open_api_doc[:components] || {}
    components_schemas = { components: components }
    # response_schema
    validation_schema = test_schemas[:schema].merge('$schema' => 'http://tempuri.org/rswag/specs/extended_schema')
                                             .merge(components_schemas)

    errors = JSON::Validator.fully_validate(validation_schema, body)
    raise RopenPi::Specs::UnexpectedResponse, "Expected response body to match schema: #{errors[0]}" if errors.any?
  end

  def extract_schemas(metadata)
    metadata[:operation] = { produces: [] } if metadata[:operation].nil?
    produces = Array(metadata[:operation][:produces])

    producer_content = produces.first || 'application/json'
    response_content = metadata[:response][:content] || { producer_content => {} }
    response_content[producer_content]
  end
end

class RopenPi::Specs::UnexpectedResponse < StandardError; end
