# frozen_string_literal: true

require "streamio-ffmpeg"

class Platform::Track::Audio::TranscodeJob < ApplicationJob
  queue_as :default

  TIERS = {
    low: { bitrate: 128 },
    mid: { bitrate: 192 },
    high: { bitrate: 320 }
  }

  def perform(original, *args)
    source = original.method_uploaded? ? original.file_url : original.bucket_uri

    file = Tempfile.new(%w[master .flac])

    if original.method_uploaded?
      URI.open(source) do |remote|
        IO.copy_stream(remote, file)
      end
    else
      bucket = Helpers::StorageManager.bucket
      bucket_file = bucket.file source, skip_lookup: true

      raise "Unable to find an audio to transcode" unless bucket_file.exists?

      bucket_file.download file.path
    end

    file.rewind

    # If this original file is imported instead of uploaded, then we should upload it
    if original.method_loaded?
      original.update(file: CarrierWave::SanitizedFile.new(file))
    end

    audio = FFMPEG::Movie.new(file.path)
    temp_files = []

    TIERS.each_pair do |key, value|
      audio_bitrate = value[:bitrate]
      path = "#{key}.mp3"
      result = audio.transcode(path, {
        audio_bitrate:,
        custom: %w[-fps_mode vfr]
      })

      original.track.audios.create!(
        size: result.size,
        duration: result.duration,
        bitrate: result.bitrate,
        sample_rate: result.audio_sample_rate,
        channels: result.audio_channels,
        format: result.audio_codec,
        file: CarrierWave::SanitizedFile.new(path),
        quality: key,
        method: :coded,
        is_master: false
      )

      temp_files << path
    end

    # remove original file and update the original's audio
    if original.method_loaded?
      filename = args.first

      raise "Missing Argument: filename" unless filename.present?

      bucket = Helpers::StorageManager.bucket
      original_remote_file = bucket.file filename, skip_lookup: true

      raise "File was not found in the bucket." unless original_remote_file.present?

      original_remote_file.delete

      original.update method: :uploaded
    end
  ensure
    file.close! if file.present?
    FileUtils.rm_f(temp_files) if temp_files.present?
  end
end
