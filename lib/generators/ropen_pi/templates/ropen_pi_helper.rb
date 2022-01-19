require 'rails_helper'

RSpec.configure do |config|
  config.root_dir = Rails.root.join('open-api').to_s
  config.open_api_docs = {
    'v1/openapi.json': {
      openapi: '3.0.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }
end
