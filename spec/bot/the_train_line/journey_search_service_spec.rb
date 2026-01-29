# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::JourneySearchService do
  let(:data_model) { instance_double('DataModel') }
  let(:parser_instance) { instance_double('Bot::TheTrainLine::Parsers::Orchestrator') }
  let(:origin) { 'koln' }
  let(:destination) { 'praha' }
  let(:departure_time) { DateTime.new(2026, 1, 29, 8, 0, 0) }

  subject(:service) { described_class.new(data_model) }

  describe '#search' do
    let(:raw_data) do
      JSON.parse(File.read('./spec/support/koln_to_praha.json'))
    end

    before do
      allow(data_model).to receive(:fetch)
        .with(origin, destination, departure_time)
        .and_return(raw_data)

      allow(Bot::TheTrainLine::Parsers::Orchestrator)
        .to receive(:new)
        .with(
          json_data: raw_data,
          departure_time: departure_time,
          origin: origin,
          destination: destination
        )
        .and_return(parser_instance)

      allow(parser_instance).to receive(:parse_entities)
      allow(parser_instance).to receive(:context).and_return(
        {
          segments: {
            'seg1' => instance_double('Segment', as_json: { id: 'seg1' }),
            'seg2' => instance_double('Segment', as_json: { id: 'seg2' })
          }
        }
      )
    end

    it 'fetches data via the data model and parses it with the orchestrator parser' do
      result = service.search(origin: origin, destination: destination, departure_time: departure_time)

      expect(data_model).to have_received(:fetch).with(origin, destination, departure_time)
      expect(Bot::TheTrainLine::Parsers::Orchestrator).to have_received(:new).with(
        json_data: raw_data,
        departure_time: departure_time,
        origin: origin,
        destination: destination
      )
      expect(parser_instance).to have_received(:parse_entities)

      expect(result).to be_a(Bot::TheTrainLine::Result)
      expect(result.success?).to be(true)
      expect(result.data).to match_array([{ id: 'seg1' }, { id: 'seg2' }])
      expect(result.error).to be_nil
      expect(result.code).to be_nil
    end

    it 'return failed result when origin is blank' do
      result = service.search(origin: '', destination: destination, departure_time: departure_time)

      expect(result).to be_a(Bot::TheTrainLine::Result)
      expect(result.success?).to be(false)
      expect(result.failure?).to be(true)
      expect(result.error).to eq('Origin cannot be blank')
      expect(result.code).to eq(:internal_error)
    end

    it 'return failed result when destination is blank' do
      result = service.search(origin: origin, destination: '', departure_time: departure_time)

      expect(result).to be_a(Bot::TheTrainLine::Result)
      expect(result.success?).to be(false)
      expect(result.failure?).to be(true)
      expect(result.error).to eq('Destination cannot be blank')
      expect(result.code).to eq(:internal_error)
    end

    it 'returns a not_found failure when DataNotFoundError is raised' do
      allow(data_model).to receive(:fetch)
        .and_raise(Bot::TheTrainLine::DataModels::DataNotFoundError.new('no data'))

      result = service.search(origin: origin, destination: destination, departure_time: departure_time)

      expect(result).to be_a(Bot::TheTrainLine::Result)
      expect(result.success?).to be(false)
      expect(result.failure?).to be(true)
      expect(result.error).to eq('no data')
      expect(result.code).to eq(:not_found)
    end

    it 'returns an internal_error failure when an unexpected error occurs' do
      allow(data_model).to receive(:fetch)
        .and_raise(StandardError.new('boom'))

      result = service.search(origin: origin, destination: destination, departure_time: departure_time)

      expect(result).to be_a(Bot::TheTrainLine::Result)
      expect(result.success?).to be(false)
      expect(result.failure?).to be(true)
      expect(result.error).to eq('boom')
      expect(result.code).to eq(:internal_error)
    end
  end

  describe '#default_data_model' do
    it 'uses DataModels::FileDataModel when no data_model is provided' do
      file_data_model = instance_double('Bot::TheTrainLine::DataModels::FileDataModel')
      allow(Bot::TheTrainLine::DataModels::FileDataModel).to receive(:new).and_return(file_data_model)

      service = described_class.new

      allow(file_data_model).to receive(:fetch).and_return({})
      allow(Bot::TheTrainLine::Parsers::Orchestrator)
        .to receive(:new)
        .and_return(parser_instance)
      allow(parser_instance).to receive(:parse_entities)
      allow(parser_instance).to receive(:context).and_return({ segments: {} })

      result = service.search(origin: origin, destination: destination)

      expect(Bot::TheTrainLine::DataModels::FileDataModel).to have_received(:new)
      expect(result).to be_a(Bot::TheTrainLine::Result)
    end
  end
end
