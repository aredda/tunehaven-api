# frozen_string_literal: true

class Platform::Album::CoverUploader < ImageUploader
  def store_dir
    "uploads/album_cover/#{model.id}"
  end

  version :full do
    process resize_to_fill: [ 200, 200 ]
  end

  version :thumb do
    process resize_to_fit: [ 50, 50 ]
  end
end
