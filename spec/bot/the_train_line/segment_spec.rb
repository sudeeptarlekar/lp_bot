# frozen_string_literal: true

describe Bot::TheTrainLine::Segment do
  let(:data) do
    {
      'id' => 'test_id',
      'departAt' => '2023-10-01T08:00:00Z',
      'arriveAt' => '2023-10-01T09:00:00Z',
      'legs' => ['test']
    }
  end

  describe '.from_json' do
    subject { described_class.from_json(data) }

    describe 'if date and time from hash is invalid' do
      let(:data) do
        { 'departAt' => 'random' }
      end

      it 'raises error' do
        expect { subject }.to raise_error Date::Error
      end
    end

    describe 'when all data in parameter is valid' do
      it 'returns segment object' do
        expect(subject.duration).to eq 60
      end
    end
  end

  describe '#calculate_duration' do
    let(:segment) { described_class.new('test_id') }

    describe 'when timezones are same' do
      before do
        segment.departure_at = DateTime.parse('2001-02-03T04:05:06+07:00')
        segment.arrival_at = DateTime.parse('2001-02-03T05:05:06+07:00')
      end

      it 'calculates travel time in minutes and updates the attribute' do
        expect(segment.duration).to eq 0
        segment.calculate_duration
        expect(segment.duration).to eq 60
      end
    end

    describe 'when timezones are different' do
      before do
        segment.departure_at = DateTime.parse('2001-02-03T04:05:06+07:00')
        segment.arrival_at = DateTime.parse('2001-02-03T06:05:06+08:00')
      end

      it 'calculates travel time in minutes and updates the attribute' do
        expect(segment.duration).to eq 0
        segment.calculate_duration
        expect(segment.duration).to eq 60
      end
    end

    describe 'when timezones are different but travel time is 0' do
      before do
        segment.departure_at = DateTime.parse('2001-02-03T04:05:06+07:00')
        segment.arrival_at = DateTime.parse('2001-02-03T05:05:06+08:00')
      end

      it 'calculates travel time in minutes and updates the attribute' do
        expect(segment.duration).to eq 0
        segment.calculate_duration
        expect(segment.duration).to eq 0
      end
    end
  end

  describe '#as_json' do
    let(:segment) { described_class.from(data) }

    it 'returns json hash from object' do
    end
  end
end
