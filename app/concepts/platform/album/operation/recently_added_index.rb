# frozen_string_literal: true

module Platform::Album::Operation
  class RecentlyAddedIndex < ApplicationOperation
    step :find_data

    def find_data(context, **)
      context[:data] = Platform::Album.order(created_at: :desc).limit(10)
    end
  end
end
