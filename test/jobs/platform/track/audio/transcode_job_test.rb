# frozen_string_literal: true

require "test_helper"

class Platform::Track::Audio::TranscodeJobTest < ActiveJob::TestCase
  def teardown
    FileUtils.rm_rf("public/test/uploads")
  end

  let(:track) { platform_tracks(:let_down) }

  it "should transcode 3 new versions of the audio" do
    audio = Fabricate(:track_audio, track:, file: Rack::Test::UploadedFile.new("test/fixtures/files/audio.flac", "audio/flac"))

    assert_difference -> { Platform::Track::Audio.count }, 3 do
      Platform::Track::Audio::TranscodeJob.perform_now(audio)

      dir = File.dirname(audio.file.path)

      assert File.exist?(File.join(dir, "128.mp3"))
      assert File.exist?(File.join(dir, "192.mp3"))
      assert File.exist?(File.join(dir, "320.mp3"))
    end
  end
end
