# frozen_string_literal: true

require 'ropen_pi/specs/request_factory'
require 'ropen_pi/specs/response_validator'

module RopenPi::Specs::ExampleHelpers
  def submit_request(metadata)
    request = RopenPi::Specs::RequestFactory.new.build_request(metadata, self)
    send(
      request[:verb],
      request[:path],
      params: request[:payload],
      headers: request[:headers]
    )
  end

  def assert_response_matches_metadata(metadata)
    RopenPi::Specs::ResponseValidator.new.validate!(metadata, response)
  end
end
