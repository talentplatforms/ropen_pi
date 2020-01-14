require 'rspec/core/rake_task'

namespace :ropen_pi do
  namespace :specs do
    desc 'Generate OpenAPI JSON files from integration specs'
    RSpec::Core::RakeTask.new('document') do |t|
      t.pattern = 'spec/requests/**/*_spec.rb, spec/api/**/*_spec.rb, spec/integration/**/*_spec.rb'

      t.rspec_opts = ['--format RopenPi::Specs::OpenApiFormatter', '--dry-run', '--order defined']
    end
  end
end
