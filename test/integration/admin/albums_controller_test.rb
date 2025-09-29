require "test_helper"
require "fileutils"

class Admin::AlbumsControllerTest < AdminIntegrationTest
  # Remove uploaded test files
  def teardown
    FileUtils.rm_rf("public/uploads")
  end

  let(:artist) { platform_artists(:radiohead) }
  let(:album) { platform_albums(:ok_computer) }

  describe "GET index" do
    it "should pass" do
      get "/api/admin/albums", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response :success
      assert_equal 2, res_data.count
      assert_equal %w[id slug title cover_thumb_url release_date tracks_count artist created_at updated_at], res_data.first.keys

      # filter by: title
      get "/api/admin/albums", headers: @auth_headers, params: {
        per_page: 10,
        page: 1,
        title: "ok c"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "OK Computer", res_data.first["title"]

      # filter by: artist_name
      get "/api/admin/albums", headers: @auth_headers, params: {
        artist_name: "RadioHead"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "OK Computer", res_data.first["title"]
    end
  end

  describe "GET autocomplete" do
    it "should pass" do
      get "/api/admin/albums/autocomplete", headers: @auth_headers, params: {
        q: "com"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "OK Computer", res_data.first["title"]
    end
  end

  describe "GET show" do
    it "should pass" do
      get "/api/admin/albums/#{album.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id slug title cover_thumb_url release_date tracks_count artist created_at updated_at], res_data.keys

      album.set_slug
      album.save

      # find by slug
      get "/api/admin/albums/radiohead-ok-computer", headers: @auth_headers

      assert_response :success
    end
    it "should fail: album is not found" do
      get "/api/admin/albums/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Album is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      assert_difference "Platform::Album.count" do
        assert_difference -> { artist.reload.albums_count } do
          post "/api/admin/albums", headers: @auth_headers, params: {
            album: {
              title: "In Rainbows",
              artist_id: artist.id,
              cover: Rack::Test::UploadedFile.new("test/fixtures/files/cover.jpg", "image/jpeg")
            }
          }

          assert_response :created
          assert_equal "radiohead-in-rainbows", res_data["slug"]
        end
      end
    end
    it "should fail: missing params" do
      assert_no_difference("Platform::Album.count") do
        post "/api/admin/albums", headers: @auth_headers, params: {
          album: {
            title: nil,
            artist_id: nil
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "must be filled", "size cannot be less than 1" ], res_errors["title"]
        assert_equal [ "must be filled" ], res_errors["artist_id"]
      end
    end
    it "should fail: duplicate album" do
      artist.albums.create title: "Hail to the thief"

      assert_no_difference("Platform::Album.count") do
        post "/api/admin/albums", headers: @auth_headers, params: {
          album: {
            title: "Hail to the thief",
            artist_id: artist.id
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "This album is already added!" ], res_errors["title"]
      end
    end
  end

  describe "PUT update" do
    it "should pass" do
      put "/api/admin/albums/#{album.id}", headers: @auth_headers, params: {
        album: {
          title: "K Computer"
        }
      }

      assert_response :success
      assert_equal "K Computer", res_data["title"]
    end
    it "should fail: album is not found" do
      put "/api/admin/albums/abc", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Album is not found!" ], res_errors["base"]
    end
  end

  describe "DELETE destroy" do
    it "should pass" do
      assert_difference "Platform::Album.count", -1 do
        delete "/api/admin/albums/#{album.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: album is not found" do
      assert_no_difference "Platform::Album.count" do
        delete "/api/admin/albums/abc", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Album is not found!" ], res_errors["base"]
      end
    end
  end
end
