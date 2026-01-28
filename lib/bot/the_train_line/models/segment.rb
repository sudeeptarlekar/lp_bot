# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Segment
      attr_reader :id, :legs
      attr_accessor :departure_station,
                    :departure_at,
                    :arrival_station,
                    :arrival_at,
                    :service_agencies,
                    :fares

      def initialize(id:, origin:, destination:, depart_at:, arrive_at:)
        @id = id
        @arrival_station = destination
        @departure_station = origin

        @departure_at = DateTime.parse(depart_at)
        @arrival_at = DateTime.parse(arrive_at)

        # WARN: JSON data from TrainLine does not have any information about service providers
        # assume for now
        @service_agencies = ['thetrainline']
        @fares = []
        @legs = []
      end

      def duration_in_minutes
        ((arrival_at - departure_at) * 24 * 60).to_i
      end

      def products
        legs.map(&:mode_name).uniq
      end

      def assign_legs(legs = [])
        @legs = []
        legs.each do |leg|
          raise InvalidLeg if leg.class != Bot::TheTrainLine::Leg

          @legs.push(leg)
        end
      end

      def changeovers
        legs.count - 1
      end

      def as_json
        {
          departure_station: departure_station,
          departure_at: departure_at,
          arrival_station: arrival_station,
          arrival_at: arrival_at,
          service_agencies: service_agencies,
          duration_in_minutes: duration_in_minutes,
          changeovers: changeovers,
          products: products,
          fares: fares.map { |fare| fare.as_json }
        }
      end
    end
  end
end
