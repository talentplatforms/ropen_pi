# frozen_string_literal: true

class RopenPi::Specs::Configuration
  def initialize(rspec_config)
    @rspec_config = rspec_config
  end

  def root_dir
    @root_dir ||= begin
      raise ConfigurationError, 'No root_dir provided. See open_api_helper.rb' if @rspec_config.root_dir.nil?

      @rspec_config.root_dir
    end
  end

  def open_api_output_format
    @open_api_output_format ||= begin
      @rspec_config.open_api_output_format
    end
  end

  def open_api_docs
    @open_api_docs ||= begin
      if @rspec_config.open_api_docs.nil? || @rspec_config.open_api_docs.empty?
        raise ConfigurationError, 'No open_api_docs defined. See open_api_helper.rb'
      end

      @rspec_config.open_api_docs
    end
  end

  def dry_run
    @dry_run ||= begin
      @rspec_config.dry_run.nil? || @rspec_config.dry_run
    end
  end

  def get_doc(name)
    return open_api_docs.values.first if name.nil?

    raise ConfigurationError, "Unknown doc '#{name}'" unless open_api_docs[name]

    open_api_docs[name]
  end
end

class ConfigurationError < StandardError; end
