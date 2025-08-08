# frozen_string_literal: true

module User::PlaylistTrack::View
  class Index < ApplicationView
    property :id
    property :track do
      property :id
      property :title
      property :duration_in_seconds
    end
    property :created_at
  end
end
