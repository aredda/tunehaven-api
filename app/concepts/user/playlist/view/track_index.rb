# frozen_string_literal: true

module User::Playlist::View
  class TrackIndex < ApplicationView
    property :id
    property :visibility
    property :title
    property :is_default
    property :is_track_added, exec_context: :decorator

    def is_track_added = represented.includes?(self.class.options[:track])
  end
end
