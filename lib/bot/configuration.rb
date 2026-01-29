# frozen_string_literal: true

module Bot
  class Configuration
    attr_accessor :data_path

    def self.default
      @@default ||= Configuration.new
    end

    def initialize
      @data_path = "./data"

      yield(self) if block_given?
    end
  end
end
