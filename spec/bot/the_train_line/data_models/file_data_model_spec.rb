# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::DataModels::FileDataModel do
  subject(:data_model) { described_class.new(data_dir: data_dir) }

  let(:data_dir) { '/tmp/data' }
  let(:origin) { 'Munich' }
  let(:destination) { 'Berlin' }
  let(:departure_time) { DateTime.parse('2026-01-01T09:00:00') }

  let(:filename) { 'munich_to_berlin.json' }
  let(:filepath) { File.join(data_dir, filename) }

  let(:file_contents) do
    {
      'data' => {
        'journeys' => [{ 'id' => 'journey-1' }]
      }
    }.to_json
  end

  describe '#initialize' do
    it 'stores the data directory' do
      expect(data_model.instance_variable_get(:@data_dir)).to eq(data_dir)
    end
  end

  describe '#fetch' do
    context 'when the file exists' do
      before do
        allow(File).to receive(:exist?).with(filepath).and_return(true)
        allow(File).to receive(:read).with(filepath).and_return(file_contents)
      end

      it 'reads the correct file based on origin and destination' do
        data_model.fetch(origin, destination, departure_time)

        expect(File).to have_received(:read).with(filepath)
      end

      it 'returns parsed data from the file' do
        result = data_model.fetch(origin, destination, departure_time)

        expect(result).to eq(
          'journeys' => [{ 'id' => 'journey-1' }]
        )
      end
    end

    context 'when the file does not exist' do
      before do
        allow(File).to receive(:exist?).with(filepath).and_return(false)
      end

      it 'raises DataNotFoundError with a helpful message' do
        expect do
          data_model.fetch(origin, destination, departure_time)
        end.to raise_error(
          Bot::TheTrainLine::DataModels::DataNotFoundError,
          'No journeys found for Munich to Berlin'
        )
      end
    end
  end

  describe 'filename formatting' do
    let(:origin) { 'New York' }
    let(:destination) { 'Los Angeles' }
    let(:filename) { 'new_york_to_los_angeles.json' }

    before do
      allow(File).to receive(:exist?).with(filepath).and_return(true)
      allow(File).to receive(:read).with(filepath).and_return(file_contents)
    end

    it 'normalizes locations to lowercase with underscores' do
      data_model.fetch(origin, destination)

      expect(File).to have_received(:exist?).with(filepath)
    end
  end
end
