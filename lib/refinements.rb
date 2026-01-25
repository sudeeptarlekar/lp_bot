# frozen_string_literal: true

module Refinements
  refine String do
    def to_filename
      downcase.gsub(/\s/, '_')
    end
  end
end
