# frozen_string_literal: true

require "test_helper"

class Admin::Tracks::AudiosControllerTest < AdminIntegrationTest
  # Remove uploaded test files
  def teardown
    FileUtils.rm_rf("public/test/uploads")
  end

  let(:track) { platform_tracks(:let_down) }
  let(:audios) { Fabricate.times(2, :track_audio, track:) }

  describe "GET index" do
    it "should fail: track is not found" do
      get "/api/admin/tracks/xyz/audios", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
    it "should pass" do
      Fabricate.times(2, :track_audio, track:)

      get "/api/admin/tracks/#{track.id}/audios", headers: @auth_headers

      assert_response :success
      assert_equal 2, res_data.count
      assert_equal %w[id duration format bitrate size channels sample_rate is_master created_at updated_at], res_data.first.keys
    end
  end

  describe "POST create" do
    it "should fail: track is not found" do
      assert_no_difference -> { track.audios.count } do
        post "/api/admin/tracks/xyz/audios", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Track is not found!" ], res_errors["base"]
      end
    end
    it "should fail: invalid type" do
      assert_no_difference -> { track.audios.count } do
        post "/api/admin/tracks/#{track.id}/audios", headers: @auth_headers, params: {
          audio: {
            file: Rack::Test::UploadedFile.new("test/fixtures/files/cover.jpg", "image/jpeg")
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "You are not allowed to upload \"jpg\" files, allowed types: flac, wav, aiff" ], res_errors["file"]
      end
    end
    it "should fail: missing file" do
      assert_no_difference -> { track.audios.count } do
        post "/api/admin/tracks/#{track.id}/audios", headers: @auth_headers, params: {
          audio: {
            file: "undefined"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "Invalid file input." ], res_errors["file"]
      end
    end
    it "should pass" do
      assert_difference -> { track.audios.count } do
        post "/api/admin/tracks/#{track.id}/audios", headers: @auth_headers, params: {
          audio: {
            file: Rack::Test::UploadedFile.new("test/fixtures/files/audio.flac", "audio/flac")
          }
        }

        assert_response :created
        assert_equal "flac", res_data["format"]
        assert_equal true, res_data["is_master"]
        assert_equal 122, res_data["duration"]
      end
    end
  end

  describe "DELETE destroy" do
    it "should fail: audio is not found" do
      assert_no_difference -> { track.audios.count } do
        delete "/api/admin/tracks/#{track.id}/audios/abc", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Audio is not found!" ], res_errors["base"]
      end
    end
    it "should fail: cannot delete a master audio" do
      audio = audios.first
      audio.update is_master: true

      assert_no_difference -> { track.audios.count } do
        delete "/api/admin/tracks/#{track.id}/audios/#{audio.id}", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Cannot delete a master audio!" ], res_errors["base"]
      end
    end
    it "should pass" do
      audio = audios.first

      assert_difference -> { track.audios.count }, -1 do
        delete "/api/admin/tracks/#{track.id}/audios/#{audio.id}", headers: @auth_headers

        assert_response :success
      end
    end
  end
end
