# frozen_string_literal: true

module User::Playlist::View
  class Base < ApplicationView
    property :id
    property :visibility
    property :title
    property :tracks_count
    property :saves_count
    property :user do
      property :id
      property :username
    end
  end
end
