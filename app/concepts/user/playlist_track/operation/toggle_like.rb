# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class ToggleLike < ApplicationOperation
    step Subprocess(DefaultShow), Output(:failure) => Track(:end)
    step :find_relationship, Output(:failure) => Id(:like)
    step :unlike, pass_fast: true
    step :like

    def find_relationship(context, current_user:, model:, **)
      context[:relationship] = current_user.liked_playlist.track_relationships.find_by(track_id: model.id)
    end

    def unlike(_context, relationship:, **)
      relationship.destroy
    end

    def like(_context, current_user:, model:, **)
      current_user.liked_playlist.track_relationships.create(track_id: model.id)
    end
  end
end
