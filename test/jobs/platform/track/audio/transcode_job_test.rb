# frozen_string_literal: true

require "test_helper"

class Platform::Track::Audio::TranscodeJobTest < ActiveJob::TestCase
  def teardown
    remove_test_uploads
  end

  let(:track) { platform_tracks(:let_down) }

  it "should transcode 3 new versions of the audio" do
    skip

    audio = Fabricate(:track_audio, track:, file: Rack::Test::UploadedFile.new("test/fixtures/files/audio.flac", "audio/flac"))

    assert_difference -> { audio.track.audios.count }, 3 do
      Platform::Track::Audio::TranscodeJob.perform_now(audio)

      dir = File.dirname(audio.file_url)
      low = audio.track.audios.quality_low.first
      mid = audio.track.audios.quality_mid.first
      high = audio.track.audios.quality_high.first

      assert_predicate low.file, :present?
      assert_predicate mid.file, :present?
      assert_predicate high.file, :present?
      assert File.exist?(File.join(dir, "low.mp3"))
      assert File.exist?(File.join(dir, "mid.mp3"))
      assert File.exist?(File.join(dir, "high.mp3"))
    end
  end

  it "should find the bucket object despite Uniform-access policy" do
    skip

    filename = "uploads/library/the-strokes/the-new-abnormal/01-the adults are talking.flac"

    bucket = ::Helpers::StorageManager.bucket
    file = bucket.file filename, skip_lookup: true

    assert file.exists?
  end

  it "should transcode an imported audio from the bucket" do
    skip

    filename = "uploads/library/the-strokes/the-new-abnormal/01-the adults are talking.flac"
    audio = Fabricate(:track_audio, quality: :original, is_master: true, track:, method: :loaded, bucket_uri: filename)

    assert_difference -> { audio.track.audios.count }, 3 do
      Platform::Track::Audio::TranscodeJob.perform_now(audio, filename)

      low = audio.track.audios.quality_low.first
      mid = audio.track.audios.quality_mid.first
      high = audio.track.audios.quality_high.first

      assert_predicate low.file, :present?
      assert_predicate mid.file, :present?
      assert_predicate high.file, :present?
      assert_predicate audio.reload.file, :present?
      assert_equal "uploaded", audio.method
    end
  end
end
