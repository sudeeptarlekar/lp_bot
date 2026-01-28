# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Fare
      attr_accessor :id, :type_id, :name

      def initialize(id:, type_id:, name:)
        @id = id
        @type_id = type_id
        @name = name
      end
    end

    class FareType
      attr_accessor :id, :code, :name

      def initialize(id:, code:, name:)
        @id = id
        @code = code
        @name = name
      end
    end

    class SegmentFare
      attr_accessor :fare_name, :money

      def initialize(fare_name:, price:, currency:)
        @fare_name = fare_name
        @money = Money.from_amount(price, currency)
      end

      def price_in_cents
        money.fractional
      end

      def currency
        money.currency.iso_code
      end

      def as_json
        {
          name: fare_name,
          price_in_cents: price_in_cents,
          currency: currency
        }
      end
    end
  end
end
