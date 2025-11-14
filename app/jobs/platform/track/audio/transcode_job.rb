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
    file = Tempfile.new([ "master", File.extname(original.file.path) ])
    URI.open(original.file_url) do |remote|
      IO.copy_stream(remote, file)
    end
    file.rewind

    puts "----- Created a temporary source file"

    # audio = FFMPEG::Movie.new(source)
    # dir = File.dirname(original.file_url)
    #
    # TIERS.each_pair do |key, value|
    #   audio_bitrate = value[:bitrate]
    #   path = File.join(dir, "#{audio_bitrate}.mp3")
    #   result = audio.transcode(path, { audio_bitrate: })
    #
    #   original.track.audios.create!(
    #     size: result.size,
    #     duration: result.duration,
    #     bitrate: result.bitrate,
    #     sample_rate: result.audio_sample_rate,
    #     channels: result.audio_channels,
    #     format: result.audio_codec,
    #     file: CarrierWave::SanitizedFile.new(path),
    #     quality: key
    #   )
    # end
  ensure
    file.close! if file
  end
end
