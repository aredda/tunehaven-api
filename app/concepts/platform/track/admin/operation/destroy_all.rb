# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class DestroyAll < ApplicationOperation
    step Model(OpenStruct, :new)
    step Contract::Build(constant: Platform::Track::Admin::Form::DestroyAll)
    step Contract::Validate()
    step :fetch_tracks
    step :destroy_all

    def fetch_tracks(context, params:, **)
      context[:model] = Platform::Track.where(id: params[:track_ids])
    end

    def destroy_all(_context, model:, **)
      model.destroy_all
    end
  end
end
