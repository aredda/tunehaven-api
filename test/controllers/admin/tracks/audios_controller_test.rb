# frozen_string_literal: true

require "test_helper"

class Admin::Tracks::AudiosControllerTest < AdminIntegrationTest
  let(:track) { platform_tracks(:let_down) }

  describe "GET index" do

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
  end

  describe "DELETE destroy" do

  end
end
