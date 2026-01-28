# frozen_string_literal

describe Bot::TheTrainLine::SegmentFare do
  let(:segment_fare) { described_class.new(fare_name: 'Comfort', price: price, currency: currency_code) }

  let(:price) { 1 }
  let(:currency_code) { 'EUR' }

  describe '#price_in_cents' do
    subject { segment_fare.price_in_cents }

    context 'when price is negative' do
      let(:price) { -1 }

      it 'returns negative price in fractions' do
        expect(subject).to eq(-100)
      end
    end

    context 'when currency fraction is different' do
      let(:currency_code) { 'KWD' }

      it 'returns fraction price of currency' do
        expect(subject).to eq(1000)
      end
    end

    context 'when price is imaginary' do
      let(:price) { Complex(1) }

      it 'returns price in fraction for real part ignoring imaginary part' do
        expect(subject).to eq(100)
      end
    end
  end

  describe '#currency' do
    subject { segment_fare.currency }

    context 'when currency code is valid' do
      it 'returns the ISO currency code' do
        expect(subject).to eq('EUR')
      end
    end

    context 'when currency code is not valid' do
      let(:currency_code) { 'TEST' }

      it 'raises an error' do
        expect { subject }.to raise_error Money::Currency::UnknownCurrency
      end
    end
  end

  describe '#as_json' do
    subject { segment_fare.as_json }

    let(:json) do
      {
        name: 'Comfort',
        price_in_cents: 100,
        currency: 'EUR'
      }
    end

    it 'returns the JSON for the object' do
      expect(subject).to eq(json)
    end
  end
end
