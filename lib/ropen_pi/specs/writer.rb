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
      def self.convert(doc)
        JSON.parse(Json.convert(doc)).to_yaml
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
