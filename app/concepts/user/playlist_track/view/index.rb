# frozen_string_literal: true

module User::PlaylistTrack::View
  class Index < ApplicationView
    property :id
    property :track do
      property :id
      property :title
      property :duration_in_seconds
      property :cover_thumb_url, getter: ->(represented:, **) { represented.album.cover.thumb.url }
    end
    property :created_at
  end
end
