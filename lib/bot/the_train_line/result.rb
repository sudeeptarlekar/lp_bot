# frozen_string_literal: true

module Bot
  module TheTrainLine
    class Result
      attr_reader :data, :error, :code

      def initialize(success:, data: nil, error: nil, code: nil)
        @success = success
        @data = data
        @error = error
        @code = code
      end

      def success?
        @success
      end

      def failure?
        !@success
      end

      def self.success(data:)
        new(success: true, data: data)
      end

      def self.failure(error:, code:)
        new(success: false, error: error, code: code)
      end
    end
  end
end
