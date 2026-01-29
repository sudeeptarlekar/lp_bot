# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Fare do
  describe '#initialize' do
    it 'sets id, type_id and name' do
      fare = described_class.new(id: 1, type_id: 10, name: 'Advance Single')

      expect(fare.id).to eq(1)
      expect(fare.type_id).to eq(10)
      expect(fare.name).to eq('Advance Single')
    end
  end

  describe 'attr_accessors' do
    it 'allows reading and writing attributes' do
      fare = described_class.new(id: 1, type_id: 10, name: 'Advance Single')

      fare.id = 2
      fare.type_id = 20
      fare.name = 'Off-Peak Return'

      expect(fare.id).to eq(2)
      expect(fare.type_id).to eq(20)
      expect(fare.name).to eq('Off-Peak Return')
    end
  end
end
