require "test_helper"

class Admin::TracksControllerTest < AdminIntegrationTest
  let(:artist) { platform_artists(:radiohead) }
  let(:album) { platform_albums(:ok_computer) }
  let(:track) { platform_tracks(:let_down) }

  describe "GET index" do
    it "should pass" do
      get "/api/admin/tracks", headers: @auth_headers, params: {
        per_page: 3,
        page: 1
      }

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id position title duration_in_seconds album artist created_at updated_at], res_data.first.keys

      # filter by: title
      get "/api/admin/tracks", headers: @auth_headers, params: {
        per_page: 10,
        page: 1,
        title: "surprises"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "No Surprises", res_data.first["title"]
      assert_equal "OK Computer", res_data.first["album"]["title"]
      assert_equal "Radiohead", res_data.first["artist"]["name"]

      # filter by: artist_name
      get "/api/admin/tracks", headers: @auth_headers, params: {
        artist_name: "RadioHead"
      }

      assert_response :success
      assert_equal 2, res_data.count
      assert_equal "No Surprises", res_data.first["title"]

      # filter by: album title
      get "/api/admin/tracks", headers: @auth_headers, params: {
        album_title: "computer",
        title: "down"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "Let Down", res_data.first["title"]
    end
  end

  describe "GET show" do
    it "should pass" do
      get "/api/admin/tracks/#{track.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id position title duration_in_seconds album artist created_at updated_at], res_data.keys
    end
    it "should fail: album is not found" do
      get "/api/admin/tracks/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      assert_difference "Platform::Track.count" do
        assert_difference -> { album.reload.tracks_count } do
          post "/api/admin/tracks", headers: @auth_headers, params: {
            track: {
              title: "Paranoid Android",
              duration_in_seconds: 387,
              album_id: album.id
            }
          }

          assert_response :created
          assert_equal "OK Computer", res_data["album"]["title"]
          assert_equal "Radiohead", res_data["artist"]["name"]
        end
      end
    end
    it "should fail: missing params" do
      assert_no_difference("Platform::Track.count") do
        post "/api/admin/tracks", headers: @auth_headers, params: {
          track: {
            title: nil,
            duration_in_seconds: -1,
            album_id: nil
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "must be filled", "size cannot be less than 1" ], res_errors["title"]
        assert_equal [ "must be filled" ], res_errors["album_id"]
        assert_equal [ "must be greater than or equal to 0" ], res_errors["duration_in_seconds"]
      end
    end
  end

  describe "PUT update" do
    it "should pass" do
      put "/api/admin/tracks/#{track.id}", headers: @auth_headers, params: {
        track: {
          title: "Karma Police"
        }
      }

      assert_response :success
      assert_equal "Karma Police", res_data["title"]
    end
    it "should fail: album is not found" do
      put "/api/admin/tracks/abc", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
  end

  describe "PUT move" do
    it "should fail: track is not found" do
      put "/api/admin/tracks/xyz/move/1", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal ["Track is not found!"], res_errors["base"]
    end
    it "should pass" do
      put "/api/admin/tracks/#{track.id}/move/1", headers: @auth_headers

      assert_response :success
      assert_equal 1, res_data["position"]

      track1 = Fabricate(:track, album:)

      put "/api/admin/tracks/#{track1.id}/move/1", headers: @auth_headers

      assert_equal 1, track1.reload.position
      assert_equal 2, track.reload.position
    end
  end

  describe "DELETE destroy" do
    it "should pass" do
      assert_difference "Platform::Track.count", -1 do
        delete "/api/admin/tracks/#{track.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: album is not found" do
      assert_no_difference "Platform::Track.count" do
        delete "/api/admin/tracks/abc", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Track is not found!" ], res_errors["base"]
      end
    end
  end
end
