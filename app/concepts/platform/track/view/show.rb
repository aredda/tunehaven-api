# frozen_string_literal: true

module Platform::Track::View
  class Show < Base
    property :artist do
      property :id
      property :slug
      property :name
    end
    property :cover_url, getter: ->(represented:, **) { represented.album.cover.full.url }
  end
end
