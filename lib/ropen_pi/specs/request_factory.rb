# frozen_string_literal: true

require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/conversions'
require 'json'

class RopenPi::Specs::RequestFactory
  def initialize(config = ::RopenPi::Specs.config)
    @config = config
  end

  def build_request(metadata, example)
    open_api_doc = @config.get_doc(metadata[:doc])
    parameters = expand_parameters(metadata, open_api_doc, example)

    {}.tap do |request|
      add_verb(request, metadata)
      add_headers(request, metadata, open_api_doc, parameters, example)
      add_path(request, metadata, open_api_doc, parameters, example)
      add_payload(request, parameters, example)
    end
  end

  private

  def expand_parameters(metadata, open_api_doc, example)
    operation_params = metadata[:operation][:parameters] || []
    path_item_params = metadata[:path_item][:parameters] || []
    security_params = derive_security_params(metadata, open_api_doc)

    # NOTE: Use of + instead of concat to avoid mutation of the metadata object
    (operation_params + path_item_params + security_params)
      .map { |p| referenced_parameter(p, open_api_doc) }
      .uniq { |p| p[:name] }
      .select { |p| example.respond_to?(p[:name]) }
  end

  # to be able to use either '$ref' => '...' or '$ref': ... syntax
  def referenced_parameter(parameter, open_api_doc)
    ref_key = '$ref'

    param = if parameter.key?(ref_key)
              parameter.fetch(ref_key, nil)
            else
              parameter.fetch(ref_key.to_sym, nil)
            end

    return parameter if param.nil?

    resolve_parameter(param, open_api_doc)
  end

  def derive_security_params(metadata, open_api_doc)
    requirements = metadata[:operation][:security] || open_api_doc[:security] || []
    scheme_names = requirements.flat_map(&:keys)
    components = open_api_doc[:components] || {}
    schemes = (components[:securitySchemes] || {}).slice(*scheme_names).values

    schemes.map do |scheme|
      param = scheme[:type] == :apiKey ? scheme.slice(:name, :in) : { name: 'Authorization', in: :header }
      param.merge(type: :string, required: requirements.one?)
    end
  end

  def resolve_parameter(ref, open_api_doc)
    key = ref.sub('#/components/parameters/', '').to_sym
    definitions = open_api_doc.dig(:components, :parameters)
    raise "Referenced parameter '#{ref}' must be defined" unless definitions && definitions[key]

    definitions[key]
  end

  def add_verb(request, metadata)
    request[:verb] = metadata[:operation][:verb]
  end

  def add_path(request, metadata, open_api_doc, parameters, example)
    template = (open_api_doc[:basePath] || '') + metadata[:path_item][:template]

    in_path = parameters.select { |p| p[:in].to_sym == :path }
    in_query = parameters.select { |p| p[:in].to_sym == :query }

    request[:path] = template.tap do |inner_template|
      in_path.each do |p|
        inner_template.gsub!("{#{p[:name]}}", example.send(p[:name]).to_s)
      end

      in_query.each.with_index do |p, i|
        inner_template.concat(i.zero? ? '?' : '&')
        inner_template.concat(build_query_string_part(p, example.send(p[:name])))
      end
    end
  end

  def build_query_string_part(param, value)
    name = param[:name]
    "#{name}=#{value}" # this needs refactoring for collections

    # all of this is deprecated and needs reimplementation
    # case param[:collectionFormat]
    # when :ssv
    #   "#{name}=#{value.join(' ')}"
    # when :tsv
    #   "#{name}=#{value.join('\t')}"
    # when :pipes
    #   "#{name}=#{value.join('|')}"
    # when :multi
    #   value.map { |v| "#{name}=#{v}" }.join('&')
    # else
    #   "#{name}=#{value.join(',')}" # csv is default
    # end
  end

  def add_headers(request, metadata, open_api_doc, parameters, example)
    tuples = parameters.select { |p| p[:in] == :header }
                       .map { |p| [p[:name], example.send(p[:name]).to_s] }
    # Accept header
    produces = metadata[:operation][:produces] || open_api_doc[:produces]
    if produces
      accept = example.respond_to?(:Accept) ? example.send(:Accept) : produces.first
      tuples << ['Accept', accept]
    end

    # Content-Type header
    consumes = metadata[:operation][:consumes] || open_api_doc[:consumes]
    if consumes
      content_type = example.respond_to?(:'Content-Type') ? example.send(:'Content-Type') : consumes.first
      tuples << ['Content-Type', content_type]
    end

    # Rails test infrastructure requires rackified headers
    rackified_tuples = tuples.map do |pair|
      [
        case pair[0]
        when 'Accept' then 'HTTP_ACCEPT'
        when 'Content-Type' then 'CONTENT_TYPE'
        when 'Authorization' then 'HTTP_AUTHORIZATION'
        else pair[0]
        end,
        pair[1]
      ]
    end

    request[:headers] = Hash[rackified_tuples]
  end

  def add_payload(request, parameters, example)
    content_type = request[:headers]['CONTENT_TYPE']
    return if content_type.nil?

    request[:payload] = if ['application/x-www-form-urlencoded', 'multipart/form-data'].include?(content_type)
                          build_form_payload(parameters, example)
                        else
                          build_json_payload(parameters, example)
                        end
  end

  def build_form_payload(parameters, example)
    # See http://seejohncode.com/2012/04/29/quick-tip-testing-multipart-uploads-with-rspec/
    # Rather that serializing with the appropriate encoding (e.g. multipart/form-data),
    # Rails test infrastructure allows us to send the values directly as a hash
    # PROS: simple to implement, CONS: serialization/deserialization is bypassed in test
    tuples = parameters.select { |p| p[:in] == :formData }
                       .map { |p| [p[:name], example.send(p[:name])] }
    Hash[tuples]
  end

  def build_json_payload(parameters, example)
    body_param = parameters.select { |p| p[:in] == :body && p[:name].is_a?(Symbol) }.first
    return nil unless body_param

    source_body_param = example.send(body_param[:name]) \
      if body_param[:name] && example.respond_to?(body_param[:name])

    source_body_param ||= body_param[:param_value]
    source_body_param ? source_body_param.to_json : nil
  end
end
