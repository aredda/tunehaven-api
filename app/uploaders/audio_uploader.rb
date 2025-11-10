# frozen_string_literal: true

class AudioUploader < BaseUploader
  def extension_allowlist
    %w[flac wav aiff mp3]
  end
end
