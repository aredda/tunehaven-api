# frozen_string_literal: true

module User::Playlist::View
  class Show < Index
    property :description
    property :user do
      property :id
      property :username
    end
    collection :tracks, decorator: Platform::Track::View::Index
  end
end
