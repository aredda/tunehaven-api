# frozen_string_literal: true

module Platform::Log::StorageSubEvent::Admin::View
  class Index < ApplicationView
    property :id
    property :type
    property :filename
    property :state
    property :created_at
  end
end
