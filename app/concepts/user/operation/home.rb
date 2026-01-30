# frozen_string_literal: true

module User::Operation
  class Home < ApplicationOperation
    step Model(OpenStruct, :new)
    pass :recently_saved
    pass :most_saved
    pass :recently_added

    def recently_saved(context, model:, **)
      result = User::Library::Operation::RecentIndex.(context)

      model.user_recent_saves = result[:data] if result.success?
    end

    def most_saved(context, model:, **)
      result = Platform::Album::Operation::MostSavedIndex.(context)

      model.most_album_saves = result[:data] if result.success?
    end

    def recently_added(context, model:, **)
      result = Platform::Album::Operation::RecentlyAddedIndex.(context)

      model.recently_added_albums = result[:data] if result.success?
    end
  end
end
