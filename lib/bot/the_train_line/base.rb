# frozen_string_literal: true

require_relative 'location'
require_relative 'fare'
require_relative 'parsers/response_parser'

module Bot
  module TheTrainLine
    class << self
      def find(from, to, departure_time)
        json_data = fetch_data(from, to)
        parser = ResponseParser.new(json_data, departure_time)
        parser.parse_fare_types
      end

      private

      def fetch_data(from, to)
        JSON.parse(File.read("./data/#{from.downcase}_to_#{to.downcase}.json"))['data']
      rescue Errno::ENOENT => _e
        puts "No journeys present between #{origin_name} to #{destination_name}"
        exit(0)
      end
    end
  end
end
