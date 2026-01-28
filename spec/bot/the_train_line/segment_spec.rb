# frozen_string_literal: true

describe Bot::TheTrainLine::Segment do
  let(:id) { 'test1234' }
  let(:origin) { 'Berlin' }
  let(:destination) { 'Munich' }
  let(:depart_at) { '2026-01-28T14:18:00+01:00' }
  let(:arrive_at) { '2026-01-28T23:31:00+01:00' }

  let(:segment) do
    described_class.new(id: id, origin: origin, destination: destination, depart_at: depart_at, arrive_at: arrive_at)
  end

  describe '.new' do
    context 'when datetimes are valid' do
      it 'returns new object' do
        expect(segment).to be_a(Bot::TheTrainLine::Segment)
      end
    end

    context 'when datetimes are invalid' do
      let(:depart_at) { '' }

      it 'raises ' do
        expect { segment }.to raise_error Date::Error
      end
    end
  end

  describe '#duration_in_minutes' do
    subject { segment.duration_in_minutes }

    context 'when timezones are same' do
      let(:depart_at) { '2001-02-03T04:05:06+07:00' }
      let(:arrive_at) { '2001-02-03T05:05:06+07:00' }

      it 'calculates travel time in minutes and updates the attribute' do
        expect(subject).to eq 60
      end
    end

    describe 'when timezones are different' do
      let(:depart_at) { '2001-02-03T04:05:06+07:00' }
      let(:arrive_at) { '2001-02-03T06:05:06+08:00' }

      it 'calculates travel time in minutes and updates the attribute' do
        expect(subject).to eq 60
      end
    end

    describe 'when timezones are different but travel time is 0' do
      let(:depart_at) { '2001-02-03T04:05:06+07:00' }
      let(:arrive_at) { '2001-02-03T05:05:06+08:00' }

      it 'calculates travel time in minutes and updates the attribute' do
        expect(subject).to eq 0
      end
    end
  end

  describe '#products' do
    subject { segment.products }

    context 'when segment is missing legs' do
      it 'returns the empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when legs are present' do
      let(:legs) do
        %w[Train Bus].map { |mode, id| Bot::TheTrainLine::Leg.new(id: id, mode_name: mode) }
      end

      before { segment.assign_legs(legs) }

      it 'returns mode of transports' do
        expect(subject).to match_array(%w[Bus Train])
      end
    end
  end

  describe '#assign_legs' do
  end

  describe '#changeovers' do
  end

  describe '#as_json' do
  end
end
