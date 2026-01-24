# frozen_string_literal: true

module User::View
  class Home < ApplicationView
    collection :user_recent_saves, decorator: User::Library::View::Index
    collection :most_album_saves, decorator: Platform::Album::View::Index
  end
end
