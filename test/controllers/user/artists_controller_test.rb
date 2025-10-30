# frozen_string_literal: true

require "test_helper"

class User::ArtistsControllerTest < UserIntegrationTest
  describe "GET index" do
    it "should get artists" do
      get "/api/user/artists", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id slug name albums_count], res_data.first.keys
      assert_equal 1, res_meta["current_page"]
    end
  end

  describe "GET show" do
    let(:artist) { platform_artists(:radiohead) }
    it "should fail: not found" do
      get "/api/user/artists/abcxyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Artist is not found" ], res_errors["base"]
    end
    it "should pass" do
      get "/api/user/artists/#{artist.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[ id slug name albums_count about ], res_data.keys
    end
  end
end
