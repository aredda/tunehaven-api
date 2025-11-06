# frozen_string_literal: true

require "test_helper"

class User::AlbumsControllerTest < UserIntegrationTest
  let(:ok_computer) { platform_albums(:ok_computer) }
  let(:let_down) { platform_tracks(:let_down) }

  describe "GET index" do
    it "should pass" do
      get "/api/user/albums", headers: @auth_headers

      assert_response :success
      assert_equal 0, res_data.count

      @user.saved_albums << ok_computer

      get "/api/user/albums", headers: @auth_headers

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal %w[id title cover_thumb_url tracks_count release_date artist], res_data.first.keys
    end
  end

  describe "GET show" do
    it "should fail: album is not found" do
      get "/api/user/albums/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Album is not found!" ], res_errors["base"]
    end
    it "should pass" do
      @user.saved_albums << ok_computer
      @user.liked_playlist.tracks << let_down

      get "/api/user/albums/#{ok_computer.id}", headers: @auth_headers

      assert_response :success
      assert_equal true, res_data["is_saved"]
    end
  end

  describe "POST toggle_save" do
    it "should fail: album is not found" do
      post "/api/user/albums/xyz/toggle_save", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Album is not found!" ], res_errors["base"]
    end
    it "should pass: saves album" do
      assert_difference -> { @user.saved_albums.count } do
        post "/api/user/albums/#{ok_computer.id}/toggle_save", headers: @auth_headers

        assert_response :success
      end
    end
    it "should pass: unsaves album" do
      @user.album_saves.create likable: ok_computer

      assert_difference -> { @user.saved_albums.count }, -1 do
        post "/api/user/albums/#{ok_computer.id}/toggle_save", headers: @auth_headers

        assert_response :success
      end
    end
  end
end
