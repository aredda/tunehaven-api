# frozen_string_literal: true

class BaseUploader < CarrierWave::Uploader::Base
  def fog_public = nil
end
