# frozen_string_literal: true

require "test_helper"

class User::TracksControllerTest < UserIntegrationTest
  describe "GET index" do
    let(:track1) { platform_tracks(:dreams) }
    let(:track2) { platform_tracks(:the_chain) }
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

  describe "PUT toggle_like" do
    let(:track) { platform_tracks(:dreams) }
    it "should fail: track is not found" do
      put "/api/user/tracks/xyz/toggle_like", headers: @auth_headers

      assert_response :unprocessable_entity
      assert_equal [ "Track is not found!" ], response.parsed_body["errors"]["base"]
    end
    it "should pass: add track to liked playlist" do
      assert_difference -> { @user.liked_playlist.track_relationships.count } do
        put "/api/user/tracks/#{track.id}/toggle_like", headers: @auth_headers

        assert_response :success
      end
    end
    it "should pass: remove track from liked playlist" do
      @user.liked_playlist.track_relationships.create track_id: track.id

      assert_difference -> { @user.liked_playlist.track_relationships.count }, -1 do
        put "/api/user/tracks/#{track.id}/toggle_like", headers: @auth_headers

        assert_response :success
      end
    end
  end
end
