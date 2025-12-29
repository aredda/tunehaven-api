# frozen_string_literal: true

module PubSub::Operation
  class Create < Process
    include Helpers::TitleFormatter

    step :is_audio, Output(:failure) => Id(:process_image)
    step :process_audio
    fall :fail_process_failed
    step :transcode_audio, pass_fast: true
    pass :process_image

    def is_audio(_context, content_type:, **)
      "audio/flac".eql? content_type
    end

    def process_audio(context, segments:, media_link:, **)
      artist_slug, album_slug, track_file = segments.first.parameterize, segments.second.parameterize, segments.third
      track_info = dissect_title track_file.split(".flac").first
      track_title = track_info[:title]

      # Create Platform::Album if it's not found
      album = find_or_initialize_album(artist_slug, album_slug)

      # Create Platform::Track instance
      track = Platform::Track.create!(
        album:,
        title: track_title.split.map(&:capitalize).join(" "),
        position: track_info[:order]
      )

      # Create Platform::Track::Audio
      context[:audio] = track.audios.create!(
        quality: :original,
        is_master: true,
        method: :loaded,
        unsigned_file_url: media_link
      )

      context[:model] = track
    end

    def fail_process_failed(_context, filename:, **)
      # Log the error
      Platform::Log::StorageSubEvent.create!(
        event_type: :added,
        filename:,
        state: :failed,
        error_message: "Processing failed"
      )
    end

    def transcode_audio(_context, audio:, **)
      Platform::Track::Audio::TranscodeJob.perform_later(audio)
    end

    def process_image(_context, segments:, filename:, bucket:, media_link:, **)
      artist_slug, album_slug, short_filename = segments.first.parameterize, segments.second.parameterize, segments.third.split(".")
      album = find_or_initialize_album(artist_slug, album_slug)

      unless album.cover.present?
        begin
          file = Tempfile.new([short_filename.first, ".#{short_filename.second}"])
          URI.open(media_link) do |remote|
            IO.copy_stream(remote, file)
          end
          file.rewind

          album.update cover: CarrierWave::SanitizedFile.new(file)

          unless media_link.include? album.reload.cover.identifier
            original_file = bucket.file filename
            original_file.delete if original_file.present?
          end
        ensure
          file.close!
        end
      end
    end

    def find_or_initialize_album(artist_slug, album_slug)
      # Create Platform::Artist if it's not found
      artist = Platform::Artist.find_or_create_by!(slug: artist_slug) do |row|
        row.name = artist_slug.titleize
      end

      # Create Platform::Album if it's not found
      Platform::Album.find_or_create_by!(slug: "#{artist_slug}-#{album_slug}") do |row|
        row.title = album_slug.titleize
        row.artist = artist
      end
    end
  end
end
