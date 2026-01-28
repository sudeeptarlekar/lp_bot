# frozen_string_literal: true

module Bot
  module TheTrainLine
    module Parsers
      class SectionParser < BaseParser
        def parse
          json_data['journeySearch']['sections'].each_with_object({}) do |(section_id, section_hash), sections|
            sections[section_id] = Section.new(id: section_id, alternatives: section_hash['alternatives'])
          end
        end
      end
    end
  end
end
