# frozen_string_literal: true

module User::Playlist::View
  class Show < Index
    property :description
    collection :tracks do
      property :id
      property :title
      property :cover_thumb_url, getter: ->(represented:, **) { represented.album.cover.thumb.url }
      property :artist do
        property :id
        property :slug
        property :name
      end
      property :duration_in_seconds
      property :is_liked, exec_context: :decorator, if: ->(**) { Show.options.present? }

      def is_liked
        Show.user.likes_track?(represented)
      end
    end
  end
end
