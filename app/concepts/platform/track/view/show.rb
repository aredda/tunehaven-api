# frozen_string_literal: true

module Platform::Track::View
  class Show < Base
    property :artist do
      property :id
      property :slug
      property :name
    end
    property :album do
      property :id
      property :slug
      property :title
      property :short_slug, getter: ->(represented:, **) { represented.title.parameterize }
    end
    property :cover_url, getter: ->(represented:, **) { represented.album.cover.full.url }
    property :cover_thumb_url, getter: ->(represented:, **) { represented.album.cover.thumb.url }
  end
end
