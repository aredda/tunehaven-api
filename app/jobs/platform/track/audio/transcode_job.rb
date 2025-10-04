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
    audio = FFMPEG::Movie.new(original.file.path)
    dir = File.dirname(original.file.path)

    TIERS.each_pair do |key, value|
      bitrate = value[:bitrate]
      path = File.join(dir, "#{bitrate}.mp3")

      result = audio.transcode(path, { bitrate: })

      original.track.audios.create!(
        size: result.size,
        duration: result.duration,
        bitrate: result.bitrate,
        sample_rate: result.audio_sample_rate,
        channels: result.audio_channels,
        format: result.audio_codec,
        file: path,
        quality: key
      )
    end
  end
end
