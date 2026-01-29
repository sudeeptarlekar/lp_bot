# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Parsers::FareParser do
  subject(:parser) { described_class.new(json_data, context) }

  let(:context) do
    {
      fare_types: fare_types
    }
  end

  let(:fare_types) do
    {
      'type-1' => Bot::TheTrainLine::FareType.new(id: 1, name: 'Standard', code: 'std'),
      'type-2' => Bot::TheTrainLine::FareType.new(id: 1, name: 'FirstClass', code: '1class')
    }
  end

  let(:json_data) do
    {
      'journeySearch' => {
        'fares' => {
          'fare-1' => {
            'id' => 'fare-1',
            'fareType' => 'type-1'
          },
          'fare-2' => {
            'id' => 'fare-2',
            'fareType' => 'type-2'
          }
        }
      }
    }
  end

  describe '#parse' do
    it 'returns a hash of fares keyed by fare id' do
      result = parser.parse

      expect(result['fare-1'].name).to eq 'Standard'
      expect(result['fare-2'].name).to eq 'FirstClass'
    end
  end
end
