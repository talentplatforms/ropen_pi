# frozen_string_literal: true

require 'ropen_pi/specs/open_api_formatter'
require 'ostruct'

module RopenPi
  module Specs
    describe OpenApiFormatter do
      subject { described_class.new(output, config) }

      # Mock out some infrastructure
      before do
        allow(config).to receive(:root_dir).and_return(root_dir)
      end

      let(:config) { double('config') }
      let(:output) { double('output').as_null_object }
      let(:root_dir) { File.expand_path('tmp/open_api', __dir__) }

      describe '#example_group_finished(notification)' do
        before do
          allow(config).to receive(:get_doc).and_return(open_api_doc)
          allow(config).to receive(:open_api_output_format).and_return(:json)
          subject.example_group_finished(notification)
        end

        let(:open_api_doc) { {} }
        let(:notification) { OpenStruct.new(group: OpenStruct.new(metadata: api_metadata)) }
        let(:api_metadata) do
          {
            path_item: { template: '/blogs' },
            operation: { verb: :post, summary: 'Creates a blog' },
            response: { code: '201', description: 'blog created' }
          }
        end

        it 'converts to open api and merges into the corresponding open api doc' do
          expect(open_api_doc).to match(
            paths: {
              '/blogs' => {
                post: {
                  summary: 'Creates a blog',
                  responses: {
                    '201' => { description: 'blog created' }
                  }
                }
              }
            }
          )
        end
      end

      describe '#stop' do
        before do
          FileUtils.rm_r(root_dir) if File.exist?(root_dir)

          allow(config).to receive(:open_api_docs).and_return(
            'v1/open_api.json' => { info: { version: 'v1' } },
            'v2/open_api.json' => { info: { version: 'v2' } }
          )
          allow(config).to receive(:open_api_output_format).and_return(:json)
          subject.stop(notification)
        end

        let(:notification) { double('notification') }

        it 'writes the swagger_doc(s) to file' do
          expect(File).to exist("#{root_dir}/v1/open_api.json")
          expect(File).to exist("#{root_dir}/v2/open_api.json")
        end

        after do
          FileUtils.rm_r(root_dir) if File.exist?(root_dir)
        end
      end
    end
  end
end
