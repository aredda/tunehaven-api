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
      assert_equal %w[id title tracks_count is_default created_at], res_data.first.keys
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
      assert_equal %w[ id title tracks_count is_default created_at description ], res_data.keys
    end
  end

  describe "POST create" do

  end

  describe "PUT update" do

  end

  describe "DELETE destroy" do

  end
end
