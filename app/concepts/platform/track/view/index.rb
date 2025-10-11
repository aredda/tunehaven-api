# frozen_string_literal: true

module Platform::Track::View
  class Index < Base
    property :cover_thumb_url, getter: ->(represented:, **) { represented.album.cover.thumb.url }
    property :artist do
      property :id
      property :slug
      property :name
    end
  end
end
