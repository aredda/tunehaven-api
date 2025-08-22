# frozen_string_literal: true

module Platform::Track::View
  class Index < ApplicationView
    property :id
    property :title
    property :duration_in_seconds
  end
end
