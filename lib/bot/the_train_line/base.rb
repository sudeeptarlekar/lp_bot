# frozen_string_literal: true

require 'refinements'
require 'money'

require_relative 'parsers/base'
require_relative 'parsers/fare_parser'
require_relative 'parsers/fare_type_parser'
require_relative 'parsers/journey_parser'
require_relative 'parsers/leg_parser'
require_relative 'parsers/orchestrator'
require_relative 'parsers/section_parser'
require_relative 'parsers/transport_mode_parser'

require_relative 'data_models/base'
require_relative 'data_models/file_data_model'
require_relative 'data_models/api_data_model'

require_relative 'journey_search_service'
require_relative 'result'

require_relative 'models/fare'
require_relative 'models/leg'
require_relative 'models/location'
require_relative 'models/section'
require_relative 'models/segment'
require_relative 'models/transport_mode'

using Refinements

module Bot
  module TheTrainLine
    class << self
      def find(from, to, departure_time = DateTime.now, data_model = default_data_model)
        # origin = Location.fetch(from)
        # destination = Location.fetch(to)

        result = JourneySearchService.new.search(origin: from, destination: to, departure_time: departure_time)
        if result.success?
          puts(JSON.pretty_generate(result.data))
          # result.data
        else
          puts "Error: #{result.error}"
          # []
        end
      end

      def default_data_model
        DataModels::FileDataModel.new
      end
    end
  end
end
