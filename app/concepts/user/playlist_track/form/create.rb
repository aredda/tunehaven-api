# frozen_string_literal: true

module User::PlaylistTrack::Form
  class Create < ApplicationForm
    property :track_id
    property :playlist_id

    validation do
      option :form

      params do
        required(:track_id).filled
        required(:playlist_id).filled
      end

      rule(:track_id) do
        key.failure("Invalid Track ID!") unless Platform::Track.exists?(id: value)
      end

      rule(:track_id) do
        key.failure("This track already belongs to this playlist!") if form.model.playlist.track_relationships.exists?(track_id: value)
      end
    end
  end
end
