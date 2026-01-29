# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Parsers::SectionParser do
  subject(:parser) { described_class.new(json_data, {}) }

  let(:json_data) do
    {
      'journeySearch' => {
        'sections' => {
          'section1' => { 'id' => 'section1', 'alternatives' => ['alternate1'] },
          'section2' => { 'id' => 'section2', 'alternatives' => ['alternate2'] }
        }
      }
    }
  end

  describe '#parse' do
    it 'returns a hash of fares keyed by fare id' do
      result = parser.parse

      expect(result['section1'].alternatives).to match_array ['alternate1']
    end
  end
end
