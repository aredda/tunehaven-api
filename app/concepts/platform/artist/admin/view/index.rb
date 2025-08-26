# frozen_string_literal: true

module Platform::Artist::Admin::View
  class Index < ApplicationView
    property :id
    property :name
    property :about
    property :created_at
    property :updated_at
  end
end
