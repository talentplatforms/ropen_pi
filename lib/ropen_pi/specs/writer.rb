module RopenPi::Specs
  # concrete
  class Writer
    # strategies
    module Json
      def self.convert(doc)
        JSON.pretty_generate(doc)
      end
    end

    module Yml
      require 'active_support/core_ext/hash/keys'

      def self.convert(doc)
        doc.deep_stringify_keys!
        doc.deep_transform_values { |value| value.to_s if value.is_a?(Symbol) }

        doc.to_yaml
      end
    end

    def initialize(open_api_output_format)
      @output_format = open_api_output_format
    end

    def write(doc)
      if @output_format == :yaml || @output_format == :yml
        Yml.convert(doc)
      else
        # this is by any means the default
        Json.convert(doc)
      end
    end
  end
end
