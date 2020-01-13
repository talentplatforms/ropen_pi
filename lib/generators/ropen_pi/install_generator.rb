require 'rails/generators'

module RopenPi
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def add_open_api_helper
      template('open_api_helper.rb', 'spec/open_api_helper.rb')
    end
  end
end
