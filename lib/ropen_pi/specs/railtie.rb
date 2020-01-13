# frozen_string_literal: true

class RopenPi::Specs::Railtie < ::Rails::Railtie
  rake_tasks do
    load File.expand_path('../../tasks/ropen_pi.rake', __dir__)
  end
end
