# frozen_string_literal: true

require "test_helper"

class User::TracksControllerTest < UserIntegrationTest
  def teardown
    FileUtils.rm_rf("public/test/uploads")
  end

  let(:track1) { platform_tracks(:dreams) }
  let(:track2) { platform_tracks(:the_chain) }

  describe "GET index" do
    it "should return liked tracks" do
      Fabricate(:user_playlist_track, playlist: @user.liked_playlist, track: track1)
      Fabricate(:user_playlist_track, playlist: @user.liked_playlist, track: track2)

      get "/api/user/tracks", headers: @auth_headers, params: {
        per_page: 1,
        page: 1
      }

      assert_response :success
      assert_equal 1, response.parsed_body["data"].count
      assert_equal 1, response.parsed_body["meta"]["current_page"]
      assert_equal 2, response.parsed_body["meta"]["total_pages"]
      assert_equal %w[id track created_at], response.parsed_body["data"].first.keys
    end
  end

  describe "GET show" do
    it "should fail: track is not found" do
      get "/api/user/tracks/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
    it "should pass" do
      get "/api/user/tracks/#{track1.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id title duration_in_seconds is_liked artist cover_url], res_data.keys
    end
  end

  describe "GET stream" do
    it "should fail: track is not found" do
      get "/api/user/tracks/xyz/stream", headers: @auth_headers

      assert_response :not_found
    end
    it "should fail: audio is not found" do
      get "/api/user/tracks/#{track1.id}/stream", headers: @auth_headers

      assert_response :not_found
    end
    it "should pass" do
      Fabricate(:track_audio, track: track1, file: Rack::Test::UploadedFile.new("test/fixtures/files/audio.flac", "audio/flac"), format: "flac")

      get "/api/user/tracks/#{track1.id}/stream", headers: @auth_headers

      assert_response :success
      assert_equal "audio/flac", response.headers["Content-Type"]
    end
  end

  describe "PUT toggle_like" do
    it "should fail: track is not found" do
      put "/api/user/tracks/xyz/toggle_like", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Track is not found!" ], response.parsed_body["errors"]["base"]
    end
    it "should pass: add track to liked playlist" do
      assert_difference -> { @user.liked_playlist.track_relationships.count } do
        put "/api/user/tracks/#{track1.id}/toggle_like", headers: @auth_headers

        assert_response :success
      end
    end
    it "should pass: remove track from liked playlist" do
      @user.liked_playlist.track_relationships.create track_id: track1.id

      assert_difference -> { @user.liked_playlist.track_relationships.count }, -1 do
        put "/api/user/tracks/#{track1.id}/toggle_like", headers: @auth_headers

        assert_response :success
      end
    end
  end

  describe "GET playlists" do
    it "should fail: track not found" do
      get "/api/user/tracks/xyz/playlists", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
    it "should pass" do
      playlist1 = Fabricate(:playlist, user: @user, title: "AAA")
      playlist2 = Fabricate(:playlist, user: @user, title: "BBB")

      playlist1.tracks << track1

      get "/api/user/tracks/#{track1.id}/playlists", headers: @auth_headers

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id visibility title is_default is_track_added tracks_count], res_data.first.keys
      assert_equal true, res_data.first["is_default"]
      assert_equal false, res_data.first["is_track_added"]
      assert_equal false, res_data.second["is_default"]
      assert_equal true, res_data.second["is_track_added"]
    end
  end
end
