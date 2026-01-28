# frozen_string_literal: true

module Bot
  module TheTrainLine
    class InvalidLocationError < StandardError
      attr_reader :location

      def initialize(location)
        @location = location

        super("Given location #{location} is invalid")
      end
    end

    class Location
      include HTTParty

      INVALID_LOCATION_CODE = 'invalid'

      attr_accessor :name, :code, :type

      base_uri 'www.thetrainline.com'

      def initialize(name:, type:, code: INVALID_LOCATION_CODE)
        @name = name
        @code = code
        @type = type
      end

      def valid?
        code != INVALID_LOCATION_CODE
      end

      def self.fetch(name)
        resp = get('/api/locations-search/v2/search', { query: { locale: 'en-us', searchTerm: name } })

        if (loc = resp['searchLocations'].first)
          return new(name: loc['name'], code: loc['code'], type: loc['locationType'])
        end

        raise Bot::TheTrainLine::InvalidLocationError, name
      end
    end
  end
end
