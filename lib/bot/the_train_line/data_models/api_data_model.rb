# frozen_string_literal: true

module Bot
  module TheTrainLine
    module DataModels
      class ApiDataMode < BaseModel
        def initialize(api_client:, base_url:)
          @api_client = api_client
          @base_url = base_url
        end

        def fetch(origin, destination, departure_time = DateTime.now)
          raise DataNotFound

          # Future implementation for real API calls
          response = @api_client.get(
            "#{@base_url}/api/journey-search",
            params: {
              origin: origin,
              destination: destination,
              departure_at: departure_time&.iso8601
            }
          )

          response['data']
        end
      end
    end
  end
end
