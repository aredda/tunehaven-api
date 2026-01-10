# frozen_string_literal: true

module Platform::Album::View
  class Index < ApplicationView
    property :id
    property :title
    property :slug
    property :short_slug, getter: ->(represented:, **) { represented.title.parameterize }
    property :cover_thumb_url, getter: ->(represented:, **) { represented.cover.thumb.url }
    property :tracks_count
    property :release_date
    property :artist do
      property :id
      property :name
      property :slug
    end
    property :is_saved, exec_context: :decorator, if: ->(**) { self.class.options.present? }

    def is_saved = self.class.user.saved_album?(represented)
  end
end
