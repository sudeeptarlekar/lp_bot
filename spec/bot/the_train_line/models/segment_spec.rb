# frozen_string_literal: true

RSpec.describe Bot::TheTrainLine::Segment do
  let(:id) { 'segment-123' }
  let(:origin) { 'London' }
  let(:destination) { 'Paris' }
  let(:depart_at) { '2001-02-03T04:05:06+07:00' }
  let(:arrive_at) { '2001-02-03T05:05:06+07:00' }
  let(:segment) do
    described_class.new(id: id, origin: origin, destination: destination, depart_at: depart_at, arrive_at: arrive_at)
  end

  describe '#initialize' do
    it 'sets the id' do
      expect(segment.id).to eq(id)
    end

    it 'sets the departure_station' do
      expect(segment.departure_station).to eq(origin)
    end

    it 'sets the arrival_station' do
      expect(segment.arrival_station).to eq(destination)
    end

    it 'parses and sets departure_at as DateTime' do
      expect(segment.departure_at).to be_a(DateTime)
      expect(segment.departure_at.to_s).to eq('2001-02-03T04:05:06+07:00')
    end

    it 'parses and sets arrival_at as DateTime' do
      expect(segment.arrival_at).to be_a(DateTime)
      expect(segment.arrival_at.to_s).to eq('2001-02-03T05:05:06+07:00')
    end

    it 'initializes service_agencies as ["thetrainline"]' do
      expect(segment.service_agencies).to eq(['thetrainline'])
    end

    it 'initializes fares as an empty array' do
      expect(segment.fares).to eq([])
    end

    it 'initializes legs as an empty array' do
      expect(segment.legs).to eq([])
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
    context 'with no legs' do
      it 'returns an empty array' do
        expect(segment.products).to eq([])
      end
    end

    context 'with legs' do
      let(:leg1) { Bot::TheTrainLine::Leg.new(id: 1, mode_name: 'train') }
      let(:leg2) { Bot::TheTrainLine::Leg.new(id: 2, mode_name: 'bus') }

      before do
        segment.assign_legs([leg1, leg2])
      end

      it 'returns unique mode names' do
        expect(segment.products).to eq(%w[train bus])
      end
    end
  end

  describe '#assign_legs' do
    let(:leg) { Bot::TheTrainLine::Leg.new(id: 1, mode_name: 'Train') }

    it 'assigns legs' do
      segment.assign_legs([leg])
      expect(segment.legs).to eq([leg])
    end

    it 'raises InvalidLeg if leg is not a Bot::TheTrainLine::Leg' do
      expect { segment.assign_legs(['not a leg']) }.to raise_error(Bot::TheTrainLine::InvalidLeg)
    end
  end

  describe '#changeovers' do
    context 'with no legs' do
      it 'returns 0' do
        expect(segment.changeovers).to eq(0)
      end
    end

    context 'with one leg' do
      let(:leg) { Bot::TheTrainLine::Leg.new(id: 1, mode_name: 'Train') }

      before { segment.assign_legs([leg]) }

      it 'returns 0' do
        expect(segment.changeovers).to eq(0)
      end
    end

    context 'with multiple legs' do
      let(:leg1) { Bot::TheTrainLine::Leg.new(id: 1, mode_name: 'Train') }
      let(:leg2) { Bot::TheTrainLine::Leg.new(id: 2, mode_name: 'Bus') }

      before { segment.assign_legs([leg1, leg2]) }

      it 'returns the number of changeovers' do
        expect(segment.changeovers).to eq(1)
      end
    end
  end

  describe '#as_json' do
    let(:fare) { Bot::TheTrainLine::SegmentFare.new(fare_name: 'Standard', price: 1, currency: 'EUR') }

    before { segment.fares << fare }

    it 'returns a hash with all attributes' do
      expect(segment.as_json).to eq(
        departure_station: origin,
        departure_at: segment.departure_at,
        arrival_station: destination,
        arrival_at: segment.arrival_at,
        service_agencies: ['thetrainline'],
        duration_in_minutes: 60,
        changeovers: 0,
        products: [],
        fares: [{ name: 'Standard', price_in_cents: 100, currency: 'EUR' }]
      )
    end
  end
end
