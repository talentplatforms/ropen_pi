# frozen_string_literal: true

require 'ropen_pi/specs/configuration'
require 'ostruct'

module RopenPi
  module Specs
    RSpec.describe Configuration do
      subject { described_class.new(rspec_config) }

      let(:rspec_config) { OpenStruct.new(root_dir: root_dir, open_api_docs: open_api_docs) }
      let(:root_dir) { 'foobar' }
      let(:open_api_docs) do
        {
          'v1/openapi.json' => { info: { title: 'v1' } },
          'v2/openapi.json' => { info: { title: 'v2' } }
        }
      end

      describe '#root_dir' do
        let(:response) { subject.root_dir }

        context 'provided in rspec config' do
          it { expect(response).to eq('foobar') }
        end

        context 'not provided' do
          let(:root_dir) { nil }
          it { expect { response }.to raise_error ConfigurationError }
        end
      end

      describe '#open_api_docs' do
        let(:response) { subject.open_api_docs }

        context 'provided in rspec config' do
          it { expect(response).to be_an_instance_of(Hash) }
        end

        context 'not provided' do
          let(:open_api_docs) { nil }
          it { expect { response }.to raise_error ConfigurationError }
        end

        context 'provided but empty' do
          let(:open_api_docs) { {} }
          it { expect { response }.to raise_error ConfigurationError }
        end
      end

      describe '#get_doc(tag=nil)' do
        let(:doc) { subject.get_doc(tag) }

        context 'no tag provided' do
          let(:tag) { nil }

          it 'returns the first doc in rspec config' do
            expect(doc).to eq(info: { title: 'v1' })
          end
        end

        context 'tag provided' do
          context 'matching doc' do
            let(:tag) { 'v2/openapi.json' }

            it 'returns the matching doc in rspec config' do
              expect(doc).to eq(info: { title: 'v2' })
            end
          end

          context 'no matching doc' do
            let(:tag) { 'foobar' }
            it { expect { doc }.to raise_error ConfigurationError }
          end
        end
      end
    end
  end
end
