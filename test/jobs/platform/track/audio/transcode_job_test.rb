# frozen_string_literal: true

require "test_helper"

class Platform::Track::Audio::TranscodeJobTest < ActiveJob::TestCase
  def teardown
    FileUtils.rm_rf("public/test/uploads")
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

  it "should transcode an imported audio from the bucket" do
    skip

    audio = Fabricate(:track_audio, track:, method: :loaded, unsigned_file_url: "https://storage.googleapis.com/download/storage/v1/b/tunehaven-bucket/o/uploads%2Flibrary%2Fradiohead%2Fok-computer%2F01.%20Airbag.flac?generation=1766588670722585&alt=media")

    assert_difference -> { audio.track.audios.count }, 3 do
      Platform::Track::Audio::TranscodeJob.perform_now(audio)

      low = audio.track.audios.quality_low.first
      mid = audio.track.audios.quality_mid.first
      high = audio.track.audios.quality_high.first

      assert_predicate low.file, :present?
      assert_predicate mid.file, :present?
      assert_predicate high.file, :present?
    end
  end
end
