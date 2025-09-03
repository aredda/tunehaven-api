# frozen_string_literal: true

require "test_helper"

class User::PlaylistsControllerTest < UserIntegrationTest
  def post_setup
    @playlists = Fabricate.times(2, :playlist, user: @user)
  end

  describe "GET index" do
    it "should get playlists" do
      get "/api/user/playlists", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id title tracks_count saves_count is_default created_at], res_data.first.keys
    end
  end

  describe "GET show" do
    it "should fail: playlist not found" do
      get "/api/user/playlists/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Playlist is not found!" ], res_errors["base"]
    end
    it "should pass" do
      get "/api/user/playlists/#{@playlists.first.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[ id title tracks_count saves_count is_default created_at description ], res_data.keys
    end
  end

  describe "POST create" do
    it "should fail: missing required params" do
      post "/api/user/playlists", headers: @auth_headers, params: {
        playlist: {
          title: nil
        }
      }

      assert_response :unprocessable_content
      assert_predicate res_errors["title"], :present?
      assert_equal [ "must be filled" ], res_errors["title"]
    end
    it "should create a playlist" do
      assert_difference -> { @user.playlists.count } do
        post "/api/user/playlists", headers: @auth_headers, params: {
          playlist: {
            title: "Mock Playlist"
          }
        }

        assert_response :created
      end
    end
  end

  describe "PUT update" do
    it "should fail: playlist not found" do
      put "/api/user/playlists/xyz", headers: @auth_headers, params: {
        playlist: {
          description: "This is a mock playlist"
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "Playlist is not found!" ], res_errors["base"]
    end
    it "should pass" do
      put "/api/user/playlists/#{@playlists.first.id}", headers: @auth_headers, params: {
        playlist: {
          title: "Mock Playlist",
          description: "This is a mock playlist"
        }
      }

      assert_response :success
      assert_equal "Mock Playlist", @playlists.first.reload.title
      assert_equal "This is a mock playlist", @playlists.first.description
    end
  end

  describe "PUT toggle_visibility" do
    it "should fail: playlist not found" do
      put "/api/user/playlists/xyz/toggle_visibility", headers: @auth_headers

      assert_response 422
      assert_equal [ "Playlist is not found!" ], res_errors["base"]
    end
    it "should fail: default playlists cannot be public" do
      put "/api/user/playlists/#{@user.liked_playlist.id}/toggle_visibility", headers: @auth_headers

      assert_response 422
      assert_equal [ "Cannot share your Liked Tracks playlist to the public!" ], res_errors["base"]
    end
    it "should pass" do
      playlist = @playlists.first

      put "/api/user/playlists/#{playlist.id}/toggle_visibility", headers: @auth_headers

      assert_response 200
      assert_equal "public", playlist.reload.visibility
    end
  end

  describe "DELETE destroy" do
    it "should fail: playlist not found" do
      assert_no_difference -> { @user.playlists.count } do
        delete "/api/user/playlists/xyz", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Playlist is not found!" ], res_errors["base"]
      end
    end
    it "should fail: default playlist is not removable" do
      @playlists.first.update is_default: true

      assert_no_difference -> { @user.playlists.count } do
        delete "/api/user/playlists/#{@playlists.first.id}", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "This playlist is irremovable!" ], res_errors["base"]
      end
    end
    it "should pass" do
      assert_difference -> { @user.playlists.count }, -1 do
        delete "/api/user/playlists/#{@playlists.last.id}", headers: @auth_headers

        assert_response :success
      end
    end
  end

  describe "POST toggle_save" do
    it "should fail: playlist is not found" do
      assert_no_difference -> { @user.saved_playlists.count } do
        post "/api/user/playlists/xyz/toggle_save", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Playlist is not found!" ], res_errors["base"]
      end
    end
    it "should fail: own playlist" do
      playlist = @playlists.first

      assert_no_difference -> { @user.saved_playlists.count } do
        post "/api/user/playlists/#{playlist.id}/toggle_save", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Cannot save your own playlist!" ], res_errors["base"]
      end
    end
    it "should pass: saves playlist" do
      playlist = Fabricate(:playlist)

      assert_difference -> { @user.saved_playlists.count } do
        post "/api/user/playlists/#{playlist.id}/toggle_save", headers: @auth_headers

        assert_response :success
        assert_equal 1, playlist.reload.saves_count
      end
    end
    it "should pass: unsaves playlist" do
      playlist = Fabricate(:playlist)
      @user.saved_playlists << playlist

      assert_difference -> { @user.saved_playlists.count }, -1 do
        post "/api/user/playlists/#{playlist.id}/toggle_save", headers: @auth_headers

        assert_response :success
        assert_equal 0, playlist.reload.saves_count
      end
    end
  end
end
