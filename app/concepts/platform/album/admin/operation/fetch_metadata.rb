# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class FetchMetadata < Show
    step :fetch_api
    fall :fail_connection_error
    step :update

    def fetch_api(context, model:, **)
      begin
        context[:metadata] = Musicbrainz::ReleaseGroup.find_by(artist: model.artist.name, title: model.title)
      rescue
        false
      end
    end

    def fail_connection_error(context, **)
      fail_error(context, "Failed to retrieve metadata from MusicBrainz")
    end

    def update(_context, metadata:, model:, **)
      model.release_date = metadata.release_date
      model.genre_ids = metadata.genres.map { |genre| genre.titleize.parameterize }
      model.save
    end
  end
end
