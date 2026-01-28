# frozen_string_literal: true

module Bot
  module TheTrainLine
    class TransportMode
      attr_accessor :id, :code, :name, :mode

      def initialize(id:, code:, name:, mode:)
        @id = id
        @name = name
        @mode = mode
        @code = code
      end
    end
  end
end
