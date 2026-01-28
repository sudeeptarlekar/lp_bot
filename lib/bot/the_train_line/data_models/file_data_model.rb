# frozen_string_literal: true

module Bot
  module TheTrainLine
    module DataModels
      class FileDataModel < BaseModel
        def initialize(data_dir: './data')
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
          location.to_s.downcase.gsub(/\s/, '_')
        end
      end
    end
  end
end
