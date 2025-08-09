# frozen_string_literal: true

module User::Playlist::Operation
  class Show < ApplicationOperation
    step :find_model
    fall :fail_not_found

    def find_model(context, current_user:, params:, **)
      context[:model] = current_user.playlists.find_by(id: params[:id])
    end

    def fail_not_found_message(_context) = "Playlist is not found!"
  end
end
