# frozen_string_literal: true

module Bot
  module TheTrainLine
    class JourneySearchService
      def initialize(data_model = nil)
        @data_model = data_model || default_data_model
        @parser = Parsers::Orchestrator
      end

      def search(origin:, destination:, departure_time: DateTime.now)
        validate_inputs!(origin, destination, departure_time)

        data = fetch_journey_data(origin, destination, departure_time)
        parse_journey_data(data, origin, destination, departure_time)
      rescue DataModels::DataNotFoundError => e
        Result.failure(error: e.message, code: :not_found)
      rescue StandardError => e
        Result.failure(error: e.message, code: :internal_error)
      end

      private

      def validate_inputs!(origin, destination, departure_time)
        raise ArgumentError, 'Origin cannot be blank' if origin.to_s.strip.empty?
        raise ArgumentError, 'Destination cannot be blank' if destination.to_s.strip.empty?
        # TODO: Skipped this validation as only static data is considered.
        # raise ArgumentError, 'Departure time must be in the future' if departure_time < DateTime.now
      end

      def parse_journey_data(data, origin, destination, departure_time)
        parser = @parser.new(json_data: data, departure_time: departure_time, origin: origin, destination: destination)
        parser.parse_entities

        Result.success(data: parser.context[:segments].values.map(&:as_json))
      end

      def fetch_journey_data(origin, destination, departure_time)
        @data_model.fetch(origin, destination, departure_time)
      end

      def default_data_model
        DataModels::FileDataModel.new
      end
    end
  end
end
