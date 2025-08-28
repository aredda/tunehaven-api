# frozen_string_literal: true

module Platform::Album::Admin::View
  class Index < ApplicationView
    property :id
    property :title
    property :cover
    property :release_date
    property :tracks_count
    property :artist do
      property :id
      property :name
    end
    property :created_at
    property :updated_at
  end
end
