# frozen_string_literal: true

class Platform::Album::CoverUploader < ImageUploader
  def store_dir
    dirs = [ model.artist.name, model.title ]

    return "test/uploads/library/#{dirs.map(&:parameterize).join("/")}" if Rails.env.test?

    "uploads/library/#{dirs.map(&:parameterize).join("/")}"
  end

  def filename
    "folder.#{file.extension}"
  end

  version :full do
    process resize_to_fill: [ 1080, 1080 ]
  end

  version :thumb do
    process resize_to_fit: [ 200, 200 ]
  end
end
