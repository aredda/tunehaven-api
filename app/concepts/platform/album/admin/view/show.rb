# frozen_string_literal: true

module Platform::Album::Admin::View
  class Show < Index
    property :id
    property :slug
    property :title
    property :cover_url, getter: ->(represented:, **) { represented.cover.full.url }
    property :release_date
    property :tracks_count
    property :artist do
      property :id
      property :slug
      property :name
    end
    collection :tracks, decorator: Platform::Track::Admin::View::Index
    property :created_at
    property :updated_at
  end
end
