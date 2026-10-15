# frozen_string_literal: true

class BaseUploader < CarrierWave::Uploader::Base
  def fog_public = nil

  # Namespace local test uploads per worker process so that a teardown in one
  # process cannot delete files another process is still using.
  def test_upload_prefix = "test/uploads/#{Process.pid}"
end
