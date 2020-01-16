require 'rspec/core'
require 'ropen_pi/specs/example_group_helpers'
require 'ropen_pi/specs/example_helpers'
require 'ropen_pi/specs/configuration'
require 'ropen_pi/specs/railtie' if defined?(Rails::Railtie)

module RopenPi
  module Specs
    # Extend RSpec with a swagger-based DSL
    ::RSpec.configure do |config|
      config.add_setting :root_dir
      config.add_setting :open_api_docs
      config.add_setting :open_api_output_format

      config.extend ExampleGroupHelpers, type: :request
      config.include ExampleHelpers, type: :request
    end

    def self.config
      @config ||= Configuration.new(RSpec.configuration)
    end
  end
end
