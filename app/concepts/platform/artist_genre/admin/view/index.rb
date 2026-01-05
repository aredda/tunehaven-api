# frozen_string_literal: true

module Platform::ArtistGenre::Admin::View
  class Index < ApplicationView
    property :id
    property :genre do
      property :id
      property :name
      property :color
    end
  end
end
