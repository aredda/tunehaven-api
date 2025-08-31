# frozen_string_literal: true

module Platform::TrackGenre::Admin::View
  class Index < ApplicationView
    property :id
    property :genre do
      property :id
      property :name
    end
    property :created_at
    property :updated_at
  end
end
