# frozen_string_literal: true

module Platform::Track::View
  class Show < ApplicationView
    property :id
    property :title
    property :duration_in_seconds
    property :cover_url, getter: ->(represented:, **) { represented.album.cover.full.url }
  end
end
