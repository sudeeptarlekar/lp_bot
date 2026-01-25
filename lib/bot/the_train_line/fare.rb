# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Fare
      attr_accessor :id, :name, :price, :currency, :type, :journey_id

      def initialize(id:, type:)
        @id = id
        @type = type
      end

      def as_json
        {
          name: name,
          price_in_cents: price,
          currency: currency,
          type: type.name
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

      def self.from_json(json)
        new(id: json['id'], code: json['code'], name: json['name'])
      end
    end
  end
end
