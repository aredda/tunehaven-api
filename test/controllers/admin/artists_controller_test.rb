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
      assert_equal %w[id name about created_at updated_at], res_data.first.keys

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

  describe "GET show" do
    it "should pass" do
      get "/api/admin/artists/#{artist.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id name about created_at updated_at], res_data.keys
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
            name: "Queen"
          }
        }

        assert_response :created
      end
    end
    it "should fail: missing params" do
      assert_no_difference("Platform::Artist.count") do
        post "/api/admin/artists", headers: @auth_headers, params: {
          artist: {
            name: nil
          }
        }

        assert_response :unprocessable_entity
        assert_equal [ "must be filled", "size cannot be less than 2" ], res_errors["name"]
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

      assert_response :unprocessable_entity
      assert_equal [ "Artist is not found!" ], res_errors["base"]
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

        assert_response :unprocessable_entity
        assert_equal [ "Artist is not found!" ], res_errors["base"]
      end
    end
  end
end
