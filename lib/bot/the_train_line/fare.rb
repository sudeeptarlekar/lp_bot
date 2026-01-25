# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Fare
      extend Forwardable

      attr_accessor :id, :type

      def_delegator :type, :name

      def initialize(id:, type:)
        @id = id
        @type = type
      end

      def valid?
        !currency.nil? && !price.nil?
      end

      def as_json
        {
          name: type.name,
          price_in_cents: price,
          currency: currency
        }
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
      attr_accessor :fare, :price, :currency

      def initialize(fare:, price:, currency:)
        @fare = fare
        @price = price
        @currency = currency
      end

      def as_json
        money = Money.from_amount(price, currency)
        {
          name: fare.name,
          price_in_cents: money.fractional,
          currency: money.currency.iso_code
        }
      end
    end
  end
end
