# frozen_string_literal: true

module Platform::Album::View
  class Index < ApplicationView
    property :id
    property :title
    property :artist do
      property :name
    end
    property :release_date
    property :tracks_count
  end
end
