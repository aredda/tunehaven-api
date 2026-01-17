# frozen_string_literal: true

class RenameAudioUnsignedFileUrl < ActiveRecord::Migration[8.0]
  def change
    rename_column :platform_track_audios, :unsigned_file_url, :bucket_uri
  end
end
