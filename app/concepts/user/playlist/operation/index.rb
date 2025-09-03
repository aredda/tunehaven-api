# frozen_string_literal: true

module User::Playlist::Operation
  class Index < ApplicationOperation
    step :set_entity
    step :set_finder

    def set_entity(context, current_user:, **)
      context[:entity] = User::Playlist.where(id: current_user.playlists + current_user.saved_playlists)
    end

    def set_finder(ctx, entity:, params:, **)
      ctx[:finder] = User::Playlist::Finder::Paginated.new(entity: entity.order(created_at: :desc), params:)
    end
  end
end
