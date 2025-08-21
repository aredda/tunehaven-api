# frozen_string_literal: true

require "test_helper"

class User::Playlists::TracksControllerTest < UserIntegrationTest
  def post_setup
    @playlist = Fabricate(:playlist, user: @user)
    @track = platform_tracks.first
  end

  describe "GET index" do
    it "should fail: playlist is not found" do
      get "/api/user/playlists/xyz/tracks", headers: @auth_headers

      assert_response 404
      assert_equal [ "Playlist is not found" ], res_errors["base"]
    end
    it "should pass" do
      platform_tracks.take(2).each do |track|
        Fabricate(:user_playlist_track, playlist: @playlist, track:)
      end

      get "/api/user/playlists/#{@playlist.id}/tracks", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response 200
      assert_equal 2, res_data.count
      assert_equal %w[id track created_at], res_data.first.keys
    end
  end

  describe "POST create" do
    it "should fail: track is not found" do
      post "/api/user/playlists/#{@playlist.id}/tracks", headers: @auth_headers, params: {
        relationship: {
          track_id: "xyz"
        }
      }

      assert_response 422
      assert_equal [ "Invalid Track ID!" ], res_errors["track_id"]
    end
    it "should fail: track is already in this playlist" do
      record = Fabricate(:user_playlist_track, playlist: @playlist, track: @track)

      post "/api/user/playlists/#{@playlist.id}/tracks", headers: @auth_headers, params: {
        relationship: {
          track_id: record.track_id
        }
      }

      assert_response 422
      assert_equal [ "This track already belongs to this playlist!" ], res_errors["track_id"], res_errors
    end
    it "should pass" do
      assert_difference -> { @playlist.track_relationships.count } do
        post "/api/user/playlists/#{@playlist.id}/tracks", headers: @auth_headers, params: {
          relationship: {
            track_id: @track.id
          }
        }

        assert_response 201
        assert_equal 1, @playlist.reload.tracks_count
      end
    end
  end

  describe "DELETE destroy" do
    it "should fail: track is not found" do
      assert_no_difference -> { @playlist.track_relationships.count } do
        delete "/api/user/playlists/abc/tracks/xyz", headers: @auth_headers

        assert_response 422
        assert_equal [ "Playlist is not found" ], res_errors["base"]

        delete "/api/user/playlists/#{@playlist.id}/tracks/xyz", headers: @auth_headers

        assert_response 422
        assert_equal [ "Track is not found!" ], res_errors["base"]
      end
    end
    it "should pass" do
      Fabricate :user_playlist_track, playlist: @playlist, track: @track

      assert_difference -> { @playlist.track_relationships.count }, -1 do
        delete "/api/user/playlists/#{@playlist.id}/tracks/#{@track.id}", headers: @auth_headers

        assert_response 200
      end
    end
  end
end
