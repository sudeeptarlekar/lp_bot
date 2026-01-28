# frozen_string_literal: true

module Bot
  module TheTrainLine
    class InvalidLeg < StandardError
      def initialize(msg = 'Invalid Leg type detected; Leg should be object of class Bot::TheTrainLine::Leg')
        super(msg)
      end
    end

    class Leg
      attr_accessor :id, :mode_name

      def initialize(id:, mode_name:)
        @id = id
        @mode_name = mode_name
      end
    end
  end
end
