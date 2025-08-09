# frozen_string_literal: true

module User::Playlist::Operation
  class Index < ApplicationOperation
    step :set_finder

    def set_finder(ctx, current_user:, params:, **)
      ctx[:finder] = User::Playlist::Finder::Paginated.new(entity: current_user.playlists.order(created_at: :desc), params:)
    end
  end
end
