# frozen_string_literal: true

module Platform::Genre::Admin::View
  class Index < ApplicationView
    property :id
    property :name
    property :description
    property :parent_id
    property :created_at
    property :updated_at
  end
end
