# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Section do
  describe '#initialize' do
    it 'sets id and alternatives with empty array default' do
      section = described_class.new(id: 'sec123')

      expect(section.id).to eq('sec123')
      expect(section.alternatives).to eq([])
    end

    it 'sets id and provided alternatives array' do
      alternatives = [
        { fare: 'Advance Single', price: 19.39 },
        { fare: 'Off-Peak', price: 25.00 }
      ]

      section = described_class.new(id: 'sec456', alternatives: alternatives)

      expect(section.id).to eq('sec456')
      expect(section.alternatives).to eq(alternatives)
    end
  end

  describe 'attr_accessors' do
    it 'allows reading and writing id and alternatives' do
      section = described_class.new(id: 'sec789')

      section.id = 'sec999'
      section.alternatives = [{ fare: 'Anytime' }]

      expect(section.id).to eq('sec999')
      expect(section.alternatives).to eq([{ fare: 'Anytime' }])
    end
  end
end
