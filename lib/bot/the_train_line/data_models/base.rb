# frozen_string_literal: true

module Bot
  module TheTrainLine
    module DataModels
      class DataNotFoundError < StandardError
      end

      class BaseModel
        def fetch(from, to, departure_time = DateTime.now)
          raise NotImplementedError, 'Subclasses must mplement the method'
        end
      end
    end
  end
end
