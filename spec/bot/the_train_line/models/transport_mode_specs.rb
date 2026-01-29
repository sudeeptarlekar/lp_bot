# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::TransportMode do
  describe '#initialize' do
    it 'sets all attributes correctly' do
      transport_mode = described_class.new(
        id: 1,
        code: 'TRAIN',
        name: 'Train',
        mode: 'rail'
      )

      expect(transport_mode.id).to eq(1)
      expect(transport_mode.code).to eq('TRAIN')
      expect(transport_mode.name).to eq('Train')
      expect(transport_mode.mode).to eq('rail')
    end
  end
end
