# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::FareType do
  describe '#initialize' do
    it 'sets id, code and name' do
      fare_type = described_class.new(id: 1, code: 'ADV', name: 'Advance')

      expect(fare_type.id).to eq(1)
      expect(fare_type.code).to eq('ADV')
      expect(fare_type.name).to eq('Advance')
    end
  end

  describe 'attr_accessors' do
    it 'allows reading and writing attributes' do
      fare_type = described_class.new(id: 1, code: 'ADV', name: 'Advance')

      fare_type.id = 2
      fare_type.code = 'OFF'
      fare_type.name = 'Off-Peak'

      expect(fare_type.id).to eq(2)
      expect(fare_type.code).to eq('OFF')
      expect(fare_type.name).to eq('Off-Peak')
    end
  end
end
