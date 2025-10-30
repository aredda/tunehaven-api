# frozen_string_literal: true

module Platform::Artist::View
  class Index < ApplicationView
    property :id
    property :slug
    property :name
    property :albums_count
  end
end
