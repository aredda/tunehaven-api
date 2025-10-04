# frozen_string_literal: true

module AdminUser::Dashboard::Operation
  class Stats < ApplicationOperation
    OPTS = {
      genres: Platform::Genre,
      artists: Platform::Artist,
      albums: Platform::Album,
      tracks: Platform::Track,
      users: User,
      audios: Platform::Track::Audio
    }

    step Model(OpenStruct, :new)
    step :count_results

    def count_results(_context, model:, **)
      OPTS.each_pair { |key, value| model[key] = value.count }
    end
  end
end
