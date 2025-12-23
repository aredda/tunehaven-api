# frozen_string_literal: true

module PubSub::Operation
  class Create < ApplicationOperation
    step :process_notification
    fall :fail_process_failed

    def process_notification(context, notification:, **)
      data = JSON.parse(notification.message.data)
      filename = data["name"]
      content_type = data["contentType"]
      remote_link = data["mediaLink"]

      return false unless %w[audio/flac].include? content_type

      return false unless filename.include? "/library/"

      entities = (filename.split "/library/").last

      return false if entities.nil?

      segments = entities.split "/"

      return false if segments.count != 3

      artist_slug, album_slug, track_file = segments.first.parameterize, segments.second.parameterize, segments.third
      track_title = track_file.split(".").first

      # Create Platform::Artist if it's not found
      artist = Platform::Artist.find_or_create_by!(slug: artist_slug) do |row|
        row.name = artist_slug.titleize
      end

      # Create Platform::Album if it's not found
      album = Platform::Album.find_or_create_by!(slug: "#{artist_slug}-#{album_slug}") do |row|
        row.title = album_slug.titleize
        row.artist = artist
      end

      # Create Platform::Track instance
      track = Platform::Track.create!(
        album:,
        title: track_title.split.map(&:capitalize).join(" ")
      )

      # Create Platform::Track::Audio
      track.audios.create!(
        quality: :original,
        is_master: true,
        method: :loaded,
        unsigned_file_url: remote_link
      )

      context[:model] = track
      context[:filename] = filename
    end

    def fail_process_failed(_context, notification:, **)
      data = JSON.parse(notification.message.data)
      filename = data["name"]

      # Log the error
      Platform::Log::StorageSubEvent.create(
        event: :added,
        filename:,
        state: :failed,
        error_message: "Processing failed"
      )
    end
  end
end
