# frozen_string_literal: true

module Platform::Album::Operation
  class MostSavedIndex < ApplicationOperation
    step :find_data

    def find_data(context, **)
      context[:data] = Platform::Album.order(likes_count: :desc).limit(10)
    end
  end
end
