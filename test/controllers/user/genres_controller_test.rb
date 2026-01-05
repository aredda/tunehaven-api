# frozen_string_literal: true

require "test_helper"

class User::GenresControllerTest < UserIntegrationTest
  let(:genre) { platform_genres(:art_rock) }
  let(:album) { platform_albums(:ok_computer) }

  describe "GET index" do
    it "should pass" do
      get "/api/user/genres", headers: @auth_headers

      assert_response :success
      assert_equal %w[ id name color ], res_data.first.keys
    end
  end

  describe "GET show" do
    it "should pass" do
      get "/api/user/genres/#{genre.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[ id name color featured description ], res_data.keys
    end
    it "should fail" do
      get "/api/user/genres/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Genre is not found" ], res_errors["base"]
    end
  end

  describe "GET featured" do
    it "should pass" do
      Platform::Genre.create(id: "rock", name: "Rock", featured: true)
      Platform::Genre.create(id: "metal", name: "Metal", featured: true)

      get "/api/user/genres/featured", headers: @auth_headers

      assert_response :success
      assert_equal 2, res_data.count
    end
  end

  describe "GET :id/albums" do
    it "should fail: genre is not found" do
      get "/api/user/genres/invalid-genre/albums", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Genre is not found" ], res_errors["base"]
    end
    it "should pass" do
      album.genres << genre

      get "/api/user/genres/#{genre.id}/albums", headers: @auth_headers

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal %w[id title cover_thumb_url tracks_count release_date artist], res_data.first.keys
      assert_equal "OK Computer", res_data.first["title"]
    end
  end
end
