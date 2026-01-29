# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Parsers::Orchestrator do
  let(:orchestrator) do
    described_class.new(
      json_data: json_data,
      departure_time: departure_time,
      origin: origin,
      destination: destination
    )
  end
  let(:json_data) { { 'journeySearch' => {} } }
  let(:departure_time) { DateTime.parse('2026-01-01T09:00:00') }
  let(:origin) { 'MUC' }
  let(:destination) { 'BER' }

  describe '#initialize' do
    it 'assigns json_data' do
      expect(orchestrator.json_data).to eq(json_data)
    end

    it 'builds context with departure_time, origin and destination' do
      expect(orchestrator.context).to eq(
        departure_time: departure_time,
        origin: origin,
        destination: destination
      )
    end
  end

  describe '#parse_entities' do
    subject { orchestrator.parse_entities }

    let(:json_data) { JSON.parse(File.read('./spec/support/koln_to_praha.json'))['data'] }

    it 'parses journeys' do
      subject
      expect(orchestrator.context[:fares]).not_to be_empty
    end
  end
end
