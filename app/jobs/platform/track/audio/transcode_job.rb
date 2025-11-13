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
    source = if Rails.env.test?
      original.file.path
    else
      file = Tempfile.new([ "source", File.extname(original.file.path) ])
      file.binmode
      URI.open(original.file.url) do |remote|
        file.write(remote.read)
      end
      file.rewind
      file.path
    end

    audio = FFMPEG::Movie.new(source)
    dir = File.dirname(original.file_url)

    TIERS.each_pair do |key, value|
      audio_bitrate = value[:bitrate]
      path = File.join(dir, "#{audio_bitrate}.mp3")
      result = audio.transcode(path, { audio_bitrate: })

      original.track.audios.create!(
        size: result.size,
        duration: result.duration,
        bitrate: result.bitrate,
        sample_rate: result.audio_sample_rate,
        channels: result.audio_channels,
        format: result.audio_codec,
        file: CarrierWave::SanitizedFile.new(path),
        quality: key
      )
    end
  ensure
    FileUtils.rm_f(source) if source && File.exist?(source) && !Rails.env.test?
  end
end
