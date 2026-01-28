# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Section
      attr_accessor :id, :alternatives

      def initialize(id:, alternatives: [])
        @id = id
        @alternatives = alternatives
      end
    end
  end
end
