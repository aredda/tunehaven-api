# frozen_string_literal: true

module Platform::Track::View
  class Show < ApplicationView
    property :id
    property :title
    property :duration_in_seconds
    property :cover_url, getter: ->(represented:, **) { represented.album.cover.full.url }
    property :is_liked, exec_context: :decorator

    def is_liked = self.class.options[:current_user].likes_track?(represented)
  end
end
