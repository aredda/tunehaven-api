# frozen_string_literal: true

module Platform::Track::View
  class Show < Base
    property :cover_url, getter: ->(represented:, **) { represented.album.cover.full.url }
  end
end
