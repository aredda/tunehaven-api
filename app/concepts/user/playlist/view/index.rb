# frozen_string_literal: true

module User::Playlist::View
  class Index < ApplicationView
    defaults render_nil: true

    property :id
    property :title
    property :tracks_count
    property :saves_count
    property :is_default
    property :is_owned, exec_context: :decorator
    property :is_saved, exec_context: :decorator
    property :created_at

    def is_owned = self.class.options[:current_user].owns_playlist?(represented)

    def is_saved = self.class.options[:current_user].saved_playlist?(represented)
  end
end
