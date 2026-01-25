# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Leg
      extend Forwardable

      attr_accessor :id, :transport_mode

      def_delegator :transport_mode, :name, :mode

      def initialize(id:, transport_mode:)
        @id = id
        @transport_mode = transport_mode
      end
    end
  end
end
