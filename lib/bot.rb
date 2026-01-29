# frozen_string_literal: true

require 'httparty'
require 'json'
require 'time'
require 'forwardable'

require 'bot/configuration'
require 'bot/the_train_line/base'

module Bot
  def self.configure
    if block_given?
      yield(Configuration.default)
    else
      Configuration.default
    end
  end
end
