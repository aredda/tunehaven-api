# frozen_string_literal: true

require "test_helper"

class Admin::ArtistsControllerTest < AdminIntegrationTest
  let(:artist) { platform_artists(:radiohead) }

  describe "GET index" do
    it "should pass" do
      get "/api/admin/artists", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id slug name about albums_count created_at updated_at], res_data.first.keys

      # filter by: name
      get "/api/admin/artists", headers: @auth_headers, params: {
        per_page: 10,
        page: 1,
        name: "radio"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "Radiohead", res_data.first["name"]
    end
  end

  describe "GET autocomplete" do
    it "should pass" do
      get "/api/admin/artists/autocomplete", headers: @auth_headers, params: {
        q: "fleet"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal %w[id name], res_data.first.keys
      assert_equal "Fleetwood Mac", res_data.first["name"]
    end
  end

  describe "GET show" do
    it "should pass" do
      get "/api/admin/artists/#{artist.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id slug name about albums_count created_at updated_at albums genres], res_data.keys

      # find by slug
      get "/api/admin/artists/radiohead", headers: @auth_headers

      assert_response :success
    end
    it "should fail: artist is not found" do
      get "/api/admin/artists/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Artist is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      assert_difference "Platform::Artist.count" do
        post "/api/admin/artists", headers: @auth_headers, params: {
          artist: {
            name: "Arctic Monkeys",
            genre_ids: [ "indie-rock" ]
          }
        }

        assert_response :created
        assert_equal "arctic-monkeys", res_data["slug"]
      end
    end
    it "should fail: name already exists" do
      assert_no_difference "Platform::Artist.count" do
        post "/api/admin/artists", headers: @auth_headers, params: {
          artist: {
            name: "Radiohead"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "This artist/band name already exists!" ], res_errors["name"]
      end
    end
    it "should fail: missing params" do
      assert_no_difference("Platform::Artist.count") do
        post "/api/admin/artists", headers: @auth_headers, params: {
          artist: {
            name: nil,
            genre_ids: [ "invalid" ]
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "must be filled", "size cannot be less than 2" ], res_errors["name"]
        assert_equal [ "[invalid] is not a valid genre!" ], res_errors["genre_ids"]
      end
    end
  end

  describe "PUT update" do
    it "should pass" do
      put "/api/admin/artists/#{artist.id}", headers: @auth_headers, params: {
        artist: {
          about: "English Rock band from the nineties"
        }
      }

      assert_response :success
      assert_equal "English Rock band from the nineties", res_data["about"]
    end
    it "should fail: artist is not found" do
      put "/api/admin/artists/abc", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Artist is not found!" ], res_errors["base"]
    end
    it "should fail: using a taken name" do
      Fabricate(:artist, name: "Muse")

      put "/api/admin/artists/#{artist.id}", headers: @auth_headers, params: {
        artist: {
          name: "Muse"
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "This artist/band name already exists!" ], res_errors["name"]
    end
  end

  describe "DELETE destroy" do
    it "should pass" do
      assert_difference "Platform::Artist.count", -1 do
        delete "/api/admin/artists/#{artist.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: artist is not found" do
      assert_no_difference "Platform::Artist.count" do
        delete "/api/admin/artists/abc", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Artist is not found!" ], res_errors["base"]
      end
    end
  end
end
