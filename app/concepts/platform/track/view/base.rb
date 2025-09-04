# frozen_string_literal: true

module Platform::Track::View
  class Base < ApplicationView
    property :id
    property :title
    property :duration_in_seconds
    property :is_liked, exec_context: :decorator, if: ->(**) { self.class.options.present? }

    def is_liked
      self.class.user.likes_track?(represented)
    end
  end
end
