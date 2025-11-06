# frozen_string_literal: true

module User::Playlist::Operation
  class ToggleSave < ApplicationOperation
    step Model::Find(User::Playlist.visibility_public, find_by: :id)
    fall :fail_not_found, fail_fast: true
    step :is_own_playlist
    fall ->(_, **) { fail_error(_, "Cannot save your own playlist!") }, fail_fast: true
    step :find_user_playlist_save
    fall :save_playlist, Output(:success) => End(:success)
    step :unsave_playlist

    def is_own_playlist(_, current_user:, params:, **)
      !current_user.playlists.exists?(id: params[:id])
    end

    def find_user_playlist_save(context, params:, current_user:, **)
      context[:model] = current_user.playlist_saves.find_by(likable_id: params[:id])
    end

    def save_playlist(_, current_user:, params:, **)
      current_user.playlist_saves.create(likable_id: params[:id])
    end

    def unsave_playlist(_, model:, **)
      model.destroy
    end

    def fail_not_found_message(_) = "Playlist is not found!"
  end
end
