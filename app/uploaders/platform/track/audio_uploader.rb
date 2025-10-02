# frozen_string_literal: true

require "streamio-ffmpeg"

class Platform::Track::AudioUploader < AudioUploader
  before :cache, :process_audio

  def process_audio(file)
    media = FFMPEG::Movie.new(file.path)

    model.size = media.size
    model.duration = media.duration
    model.bitrate = media.bitrate
    model.sample_rate = media.audio_sample_rate
    model.channels = media.audio_channels
    model.format = media.audio_codec
    model.is_master = model.track.audios.count.zero?
  end

  def store_dir
    dirs = [ model.track.artist.name, model.track.album.title, model.track.title ]

    return "test/uploads/library/#{dirs.map(&:parameterize).join("/")}" if Rails.env.test?

    "uploads/library/#{dirs.map(&:parameterize).join("/")}"
  end

  def filename
    "#{model.bitrate}.#{model.format}"
  end
end
