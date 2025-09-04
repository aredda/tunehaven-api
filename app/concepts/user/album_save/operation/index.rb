# frozen_string_literal: true

module User::AlbumSave::Operation
  class Index < ApplicationOperation
    step :set_finder

    def set_finder(context, current_user:, params:, **)
      context[:finder] = User::AlbumSave::Finder::Base.new(entity: current_user.saved_albums.joins(:user_saves).order(user_saves: { created_at: :desc }), params:)
    end
  end
end
