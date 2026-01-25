# frozen_string_literal: true

describe Bot::TheTrainLine::Location do
  describe '#valid?' do
    it 'returns false is code is set to `invalid`' do
      location = described_class.new(name: 'London', type: 'station')
      expect(location.valid?).to be false
    end
  end

  describe '.fetch' do
    before do
      allow(Bot::TheTrainLine::Location).to receive(:get)
        .with('/api/locations-search/v2/search', { query: { locale: 'en-us', searchTerm: name } })
        .and_return(response)
    end

    describe 'when location is valid' do
      let(:name) { 'London' }
      let(:response) do
        {
          'searchLocations' => [
            {
              'name' => 'London',
              'locationType' => 'station',
              'code' => 'test'
            }
          ]
        }
      end

      it 'makes the api call and fetches the location data' do
        location = described_class.fetch(name)
        expect(location.valid?).to be true
        expect(location.type).to eq 'station'
      end
    end

    describe 'when location is invalid' do
      let(:name) { 'fake' }
      let(:response) do
        {
          'searchLocations' => []
        }
      end

      it 'raises InvalidLocationError' do
        expect { described_class.fetch(name) }.to raise_error Bot::TheTrainLine::InvalidLocationError
      end
    end
  end
end
