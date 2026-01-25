# frozen_string_literal

describe Bot::TheTrainLine::Fare do
end

describe Bot::TheTrainLine::FareType do
  describe '.from_json' do
    subject { described_class.from_json(json_data) }

    let(:json_data) do
      { 'id' => 'test123', 'code' => 'code', 'name' => 'Premium' }
    end

    it 'builds the FareType object from json data' do
      expect(subject.id).to eq('test123')
    end
  end
end
