# frozen_string_literal: true

module Platform::Track::Audio::Admin::View
  class Index < ApplicationView
    property :id
    property :duration
    property :format
    property :bitrate
    property :size
    property :channels
    property :sample_rate
    property :is_master
    property :created_at
    property :updated_at
  end
end
