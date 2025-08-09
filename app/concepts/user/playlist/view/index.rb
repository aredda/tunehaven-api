# frozen_string_literal: true

module User::Playlist::View
  class Index < ApplicationView
    defaults render_nil: true

    property :id
    property :title
    property :tracks_count
    property :is_default
    property :created_at
  end
end
