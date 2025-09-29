# frozen_string_literal: true

class ImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  def extension_allowlist
    %w[jpg jpeg png]
  end
end
