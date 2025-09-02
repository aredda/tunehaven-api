class CreatePlatformTrackAudios < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_track_audios, id: :uuid do |t|
      t.uuid :track_id, null: false
      t.string :format
      t.string :bitrate
      t.string :file

      t.foreign_key :platform_tracks, column: :track_id

      t.timestamps
    end
  end
end
