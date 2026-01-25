# frozen_string_literal: true

require_relative 'location'
require_relative 'fare'
require_relative 'leg'
require_relative 'transport_mode'
require_relative 'section'
require_relative 'segment'
require_relative 'parsers/response_parser'

require 'refinements'

using Refinements

module Bot
  module TheTrainLine
    class << self
      def find(from, to, departure_time = DateTime.now)
        # origin = Location.fetch(from)
        # destination = Location.fetch(to)

        json_data = fetch_data(from, to)
        parser = ResponseParser.new(json_data, departure_time, from, to)
        parser.parse
        puts(JSON.pretty_generate(parser.journeys.map { |_id, journey| journey.as_json }))
      end

      private

      def fetch_data(origin, destination)
        JSON.parse(File.read("./data/#{origin.to_filename}_to_#{destination.to_filename}.json"))['data']
      rescue Errno::ENOENT => _e
        puts "No journeys present between #{origin.name} to #{destination.name}"
        exit(0)
      end
    end
  end
end
