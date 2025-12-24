# frozen_string_literal: true

require "streamio-ffmpeg"

class Platform::Track::Audio::TranscodeJob < ApplicationJob
  queue_as :default

  TIERS = {
    low: { bitrate: 128 },
    mid: { bitrate: 192 },
    high: { bitrate: 320 }
  }

  def perform(original)
    source = original.method_uploaded? ? original.file_url : original.unsigned_file_url

    file = Tempfile.new(%w[master flac])
    URI.open(source) do |remote|
      IO.copy_stream(remote, file)
    end
    file.rewind

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
  ensure
    file.close! if file
    FileUtils.rm_f(temp_files) if temp_files.count.positive?
  end
end
