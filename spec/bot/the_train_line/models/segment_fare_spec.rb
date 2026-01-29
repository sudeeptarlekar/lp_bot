# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::SegmentFare do
  let(:fare_name) { 'Advance Single' }
  let(:price) { 19.39 }
  let(:currency) { 'GBP' }

  describe '#initialize' do
    it 'sets fare_name and builds a Money object' do
      segment_fare = described_class.new(
        fare_name: fare_name,
        price: price,
        currency: currency
      )

      expect(segment_fare.fare_name).to eq('Advance Single')
      expect(segment_fare.money).to be_a(Money)
      expect(segment_fare.money.cents).to eq(1939)
      expect(segment_fare.money.currency.iso_code).to eq('GBP')
    end
  end

  describe '#price_in_cents' do
    it 'returns the price in cents from the Money object' do
      segment_fare = described_class.new(
        fare_name: fare_name,
        price: price,
        currency: currency
      )

      expect(segment_fare.price_in_cents).to eq(1939)
    end
  end

  describe '#currency' do
    it 'returns the ISO currency code from the Money object' do
      segment_fare = described_class.new(
        fare_name: fare_name,
        price: price,
        currency: currency
      )

      expect(segment_fare.currency).to eq('GBP')
    end
  end

  describe '#as_json' do
    it 'returns the expected hash representation' do
      segment_fare = described_class.new(
        fare_name: fare_name,
        price: price,
        currency: currency
      )

      expect(segment_fare.as_json).to eq(
        name: 'Advance Single',
        price_in_cents: 1939,
        currency: 'GBP'
      )
    end
  end
end
