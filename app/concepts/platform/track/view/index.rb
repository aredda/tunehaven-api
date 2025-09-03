# frozen_string_literal: true

module Platform::Track::View
  class Index < ApplicationView
    property :id
    property :title
    property :duration_in_seconds
    property :cover_thumb_url, getter: ->(represented:, **) { represented.album.cover.thumb.url }
    property :is_liked, exec_context: :decorator

    def is_liked = self.class.options[:current_user].likes_track?(represented)
  end
end
