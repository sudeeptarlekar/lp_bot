# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Parsers::FareTypeParser do
  subject(:parser) { described_class.new(json_data, {}) }

  let(:json_data) do
    {
      'fareTypes' => {
        'type1' => { 'id' => 'type1', 'code' => 'std', 'name' => 'Standard' },
        'type2' => { 'id' => 'type2', 'code' => 'flex', 'name' => 'Superflex' }
      }
    }
  end

  describe '#parse' do
    it 'returns a hash of fares keyed by fare id' do
      result = parser.parse

      expect(result['type1'].name).to eq 'Standard'
      expect(result['type2'].name).to eq 'Superflex'
    end
  end
end
