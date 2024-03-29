require 'ropen_pi/config_helper'

module RopenPi
  describe Param do
    describe "#param" do
      it "returns expected hash" do
        expected_result = { name: "uuid", description: "tba", in: "query", schema: { type: "null" } }

        expect(RopenPi::Param.param(:uuid, 'null')).to eq(expected_result)
      end

      describe '#header' do
        it 'accepts a param set in the header section' do
          expected = {
            name: 'Accept-Encoding',
            description: 'tba',
            in: 'header',
            required: false,
            schema: {
              type: 'string'
            }
          }

          expect(RopenPi::Param.param_in_header(:'Accept-Encoding', 'string')).to eq(expected)
        end
      end
    end

    # TODO; extend test cases to ("catch") cover them all
  end

  describe Type do
    describe '#date_time_type' do
      it "called without opt parameters" do
        expected_result = { type: "string", example: "2020-02-02", format: "date-time" }

        expect(RopenPi::Type.date_time_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "string", example: "2021-02-02", format: "date-time" }

        expect(RopenPi::Type.date_time_type({ example: "2021-02-02" })).to eq(expected_result)
      end
    end

    describe '#email_type' do
      it "called without opt parameters" do
        expected_result = { type: "string", example: "han.solo@example.com", format: "email" }

        expect(RopenPi::Type.email_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "string", example: "luke.skywalker@example.com", format: "email" }

        expect(RopenPi::Type.email_type({ example: "luke.skywalker@example.com" })).to eq(expected_result)
      end
    end

    describe '#uuid_type' do
      it "called without opt parameters" do
        expected_result = { type: "string", example: "abcd12-1234ab-abcdef123", format: "uuid" }

        expect(RopenPi::Type.uuid_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "string", example: "xyz12-1234ab-abcdef123", format: "uuid" }

        expect(RopenPi::Type.uuid_type({ example: "xyz12-1234ab-abcdef123" })).to eq(expected_result)
      end
    end

    describe '#string_type' do
      it "called without opt parameters" do
        expected_result = { type: "string", example: "Example string" }

        expect(RopenPi::Type.string_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "string", example: "The new example String" }

        expect(RopenPi::Type.string_type({ example: "The new example String" })).to eq(expected_result)
      end
    end

    describe '#integer_type' do
      it "called without opt parameters" do
        expected_result = { type: "integer", example: 1 }

        expect(RopenPi::Type.integer_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "integer", example: 2 }

        expect(RopenPi::Type.integer_type({ example: 2 })).to eq(expected_result)
      end
    end

    describe '#type' do
      it "called without opt parameters" do
        expected_result = { type: "integer"}

        expect(RopenPi::Type.type("integer")).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { type: "sith", side: "darkside" }

        expect(RopenPi::Type.type("sith", { side: "darkside" })).to eq(expected_result)
      end
    end

    describe '#string_array_type' do
      it "called without opt parameters" do
        expected_result = { items: { example: "Example string", type: "string"}, type: "array"}

        expect(RopenPi::Type.string_array_type).to eq(expected_result)
      end

      it "called with opt parameters" do
        expected_result = { items: { example: "Example string", type: "string"}, type: "array", test: "123"}

        expect(RopenPi::Type.string_array_type({ test: "123" })).to eq(expected_result)
      end
    end
  end
end
