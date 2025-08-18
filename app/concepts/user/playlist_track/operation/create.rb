# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class Create < ApplicationOperation
    step Subprocess(FetchPlaylist), Output(:failure) => Track(:end)
    step :build_model
    step Contract::Build(constant: User::PlaylistTrack::Form::Create)
    step Contract::Validate(key: :relationship)
    step Contract::Persist()

    def build_model(context, playlist:, **)
      context[:model] = playlist.track_relationships.build
    end
  end
end
