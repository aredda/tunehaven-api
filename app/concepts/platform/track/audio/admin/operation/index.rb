# frozen_string_literal: true

module Platform::Track::Audio::Admin::Operation
  class Index < FetchTrack
    step :set_finder

    def set_finder(context, model:, params:, **)
      context[:finder] = Platform::Track::Audio::Admin::Finder::Base.new(entity: model.audios.order(created_at: :desc), params:)
    end
  end
end
