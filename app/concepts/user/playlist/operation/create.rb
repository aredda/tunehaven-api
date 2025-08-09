# frozen_string_literal: true

module User::Playlist::Operation
  class Create < ApplicationOperation
    step :build_model
    step Contract::Build(constant: User::Playlist::Form::Create)
    step Contract::Validate(key: :playlist)
    step Contract::Persist()

    def build_model(context, current_user:, **)
      context[:model] = current_user.playlists.build
    end
  end
end
