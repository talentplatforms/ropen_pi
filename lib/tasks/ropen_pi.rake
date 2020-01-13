require 'rspec/core/rake_task'

namespace :ropen_pi do
  namespace :specs do
    desc 'Generate Swagger JSON files from integration specs'
    RSpec::Core::RakeTask.new('swaggerize') do |t|
      t.pattern = 'spec/requests/**/*_spec.rb, spec/api/**/*_spec.rb, spec/integration/**/*_spec.rb'

      t.rspec_opts = [ '--format OpenApi::Rswag::Specs::SwaggerFormatter', '--dry-run', '--order defined' ]
      # # NOTE: rspec 2.x support
      # if OpenApi::Rswag::Specs::RSPEC_VERSION > 2 && OpenApi::Rswag::Specs.config.swagger_dry_run
      # else
      #   t.rspec_opts = [ '--format OpenApi::Rswag::Specs::SwaggerFormatter', '--order defined' ]
      # end
    end
  end
end
