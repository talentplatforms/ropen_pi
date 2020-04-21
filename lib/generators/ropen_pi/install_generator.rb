require 'rails/generators'
module Generators
  module RopenPi
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def add_open_api_helper
        template('ropen_pi_helper.rb', 'spec/ropen_pi_helper.rb')
      end
    end
  end
end
