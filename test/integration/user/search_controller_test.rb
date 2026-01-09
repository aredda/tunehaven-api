# frozen_string_literal: true

require "test_helper"

class User::SearchControllerTest < UserIntegrationTest
  let(:track) { platform_tracks(:the_chain) }

  describe "GET search" do
    it "should fail: invalid type" do
      get "/api/user/search", headers: @auth_headers, params: {
        type: "invalid"
      }

      assert_response 422
      assert_equal [ "Invalid type: must be either 'track', 'album', 'artist' or 'playlist'" ], res_errors["base"]
    end
    it "should search for tracks" do
      @user.liked_playlist.tracks << track

      get "/api/user/search", headers: @auth_headers, params: {
        type: "track"
      }

      assert_response 200
      assert_equal 4, res_data.count
      assert_equal %w[ id title duration_in_seconds is_liked cover_thumb_url artist ], res_data.first.keys

      # filter by query
      get "/api/user/search", headers: @auth_headers, params: {
        type: "track",
        query: "chain"
      }

      assert_response 200
      assert_equal 1, res_data.count
      assert_equal "The Chain", res_data.first["title"]
      assert_equal true, res_data.first["is_liked"]
    end
    it "should search for albums" do
      get "/api/user/search", headers: @auth_headers, params: {
        type: "album"
      }

      assert_response 200
      assert_equal 2, res_data.count
      assert_equal %w[ id title slug short_slug cover_thumb_url tracks_count release_date artist ], res_data.first.keys

      # filter by query
      get "/api/user/search", headers: @auth_headers, params: {
        type: "album",
        query: "ok"
      }

      assert_response 200
      assert_equal 1, res_data.count
      assert_equal "OK Computer", res_data.first["title"]
    end
    it "should search for artists" do
      get "/api/user/search", headers: @auth_headers, params: {
        type: "artist"
      }

      assert_response 200
      assert_equal 3, res_data.count
      assert_equal %w[ id slug name albums_count ], res_data.first.keys

      # filter by query
      get "/api/user/search", headers: @auth_headers, params: {
        type: "artist",
        query: "fleet"
      }

      assert_response 200
      assert_equal 1, res_data.count
      assert_equal "Fleetwood Mac", res_data.first["name"]
    end
    it "should search for playlists" do
      Fabricate(:playlist, visibility: :private, user: @user)
      Fabricate(:playlist, visibility: :public, user: @user, title: "Visible to the naked eye")
      Fabricate.times(2, :playlist, user: @user, visibility: :public)

      get "/api/user/search", headers: @auth_headers, params: {
        type: "playlist"
      }

      assert_response 200
      assert_equal 3, res_data.count
      assert_equal %w[ id visibility title tracks_count saves_count user ], res_data.first.keys

      get "/api/user/search", headers: @auth_headers, params: {
        type: "playlist",
        query: "naked"
      }

      assert_response 200
      assert_equal 1, res_data.count
      assert_equal "Visible to the naked eye", res_data.first["title"]
    end
  end
end
