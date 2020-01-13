require 'rspec/core'
require 'ropen_pi/specs/example_group_helpers'
require 'ropen_pi/specs/example_helpers'
require 'ropen_pi/specs/configuration'
require 'ropen_pi/specs/railtie' if defined?(Rails::Railtie)

module RopenPi
  module Specs
    # Extend RSpec with a swagger-based DSL
    ::RSpec.configure do |c|
      c.add_setting :root_dir
      c.add_setting :open_api_docs
      c.add_setting :dry_run
      c.add_setting :open_api_output_format

      c.extend ExampleGroupHelpers, type: :request
      c.include ExampleHelpers, type: :request
    end

    def self.config
      @config ||= Configuration.new(RSpec.configuration)
    end
  end
end
