# frozen_string_literal: true

module Platform::Track::Admin::View
  class Index < ApplicationView
    property :id
    property :position
    property :title
    property :duration_in_seconds
    property :album do
      property :id
      property :title
    end
    property :artist do
      property :id
      property :name
    end
    property :audios_count
    property :created_at
    property :updated_at
  end
end
