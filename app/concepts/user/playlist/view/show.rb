# frozen_string_literal: true

module User::Playlist::View
  class Show < Index
    property :description
    collection :tracks, decorator: Platform::Track::View::Index
  end
end
