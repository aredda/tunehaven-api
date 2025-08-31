# frozen_string_literal: true

module Platform::Album::Admin::View
  class Index < ApplicationView
    property :id
    property :title
    property :cover_thumb_url, getter: ->(represented:, **) { represented.cover.thumb.url }
    property :release_date
    property :tracks_count
    property :artist do
      property :id
      property :name
    end
    property :created_at
    property :updated_at
  end
end
