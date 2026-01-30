# frozen_string_literal: true

module Platform::Album::Operation
  class ByGenreIndex < Platform::Genre::Operation::Show
    step :set_finder

    def set_finder(context, model:, params:, **)
      context[:finder] = ApplicationFinder.new(entity: model.albums.order(likes_count: :asc), params:)
    end
  end
end
