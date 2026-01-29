# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::DataModels::ApiDataMode do
  subject(:data_model) do
    described_class.new(
      api_client: api_client,
      base_url: base_url
    )
  end

  let(:api_client) { instance_double('ApiClient') }
  let(:base_url) { 'https://example.com' }

  describe '#initialize' do
    it 'stores api_client' do
      expect(data_model.instance_variable_get(:@api_client)).to eq(api_client)
    end

    it 'stores base_url' do
      expect(data_model.instance_variable_get(:@base_url)).to eq(base_url)
    end
  end

  describe '#fetch' do
    let(:origin) { 'MUC' }
    let(:destination) { 'BER' }
    let(:departure_time) { DateTime.parse('2026-01-01T09:00:00') }

    it 'raises DataNotFoundError' do
      expect do
        data_model.fetch(origin, destination, departure_time)
      end.to raise_error(Bot::TheTrainLine::DataModels::DataNotFoundError)
    end

    it 'does not call the api client yet' do
      expect(api_client).not_to receive(:get)

      begin
        data_model.fetch(origin, destination, departure_time)
      rescue Bot::TheTrainLine::DataModels::DataNotFoundError
        # expected
      end
    end
  end
end
