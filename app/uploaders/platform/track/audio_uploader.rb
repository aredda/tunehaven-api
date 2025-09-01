# frozen_string_literal: true

class Platform::Track::AudioUploader < AudioUploader
  def store_dir
    "uploads/library/#{model.track.artist.name}/#{model.track.album.title}/#{model.track.title}"
  end
end
