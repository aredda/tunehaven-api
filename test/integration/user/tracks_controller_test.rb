# frozen_string_literal: true

require "test_helper"

class User::TracksControllerTest < UserIntegrationTest
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
