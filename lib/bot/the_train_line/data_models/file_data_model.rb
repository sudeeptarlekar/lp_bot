# frozen_string_literal: true

using Refinements

module Bot
  module TheTrainLine
    module DataModels
      class FileDataModel < BaseModel
        def initialize(data_dir: Bot::Configuration.default.data_path)
          @data_dir = data_dir
        end

        def fetch(origin, destination, departure_time = DateTime.now)
          filename = "#{format_location(origin)}_to_#{format_location(destination)}.json"
          filepath = File.join(@data_dir, filename)

          raise DataNotFoundError, "No journeys found for #{origin} to #{destination}" unless File.exist?(filepath)

          JSON.parse(File.read(filepath))['data']
        end

        private

        def format_location(location)
          location.to_s.to_filename
        end
      end
    end
  end
end
