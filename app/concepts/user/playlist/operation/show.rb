# frozen_string_literal: true

module User::Playlist::Operation
  class Show < ApplicationOperation
    step Model::Find(User::Playlist.visibility_public, find_by: :id)
    fall :fail_not_found

    def fail_not_found_message(_context) = "Playlist is not found!"
  end
end
