# frozen_string_literal: true

require "test_helper"

class Admin::GenresControllerTest < AdminIntegrationTest
  let(:genre) { platform_genres(:art_rock) }

  describe "GET index" do
    it "should pass" do
      get "/api/admin/genres", headers: @auth_headers, params: {
        per_page: 10,
        page: 1
      }

      assert_response :success
      assert_equal 2, res_data.count
      assert_equal %w[id name color description parent_id created_at updated_at], res_data.first.keys

      # filter by: name
      get "/api/admin/genres", headers: @auth_headers, params: {
        per_page: 10,
        page: 1,
        name: "art"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "Art Rock", res_data.first["name"]
    end
  end

  describe "GET autocomplete" do
    it "should pass" do
      get "/api/admin/genres/autocomplete", headers: @auth_headers, params: {
        q: "rock"
      }

      assert_response :success
      assert_equal 2, res_data.count

      get "/api/admin/genres/autocomplete", headers: @auth_headers, params: {
        q: "art"
      }

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal "art-rock", res_data.first["id"]
      assert_equal "Art Rock", res_data.first["name"]
    end
  end

  describe "GET show" do
    it "should pass" do
      get "/api/admin/genres/#{genre.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id name color description parent_id created_at updated_at], res_data.keys
    end
    it "should fail: genre is not found" do
      get "/api/admin/genres/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Genre is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      assert_difference "Platform::Genre.count" do
        post "/api/admin/genres", headers: @auth_headers, params: {
          genre: {
            name: "Progressive Rock"
          }
        }

        assert_response :created
        assert_equal "progressive-rock", res_data["id"]
      end
    end
    it "should pass: assign a parent genre" do
      assert_difference "Platform::Genre.count" do
        post "/api/admin/genres", headers: @auth_headers, params: {
          genre: {
            name: "Art Pop",
            parent_id: genre.id
          }
        }

        assert_response :created
        assert_equal "art-pop", res_data["id"]
      end
    end
    it "should fail: parent genre is not found" do
      assert_no_difference "Platform::Genre.count" do
        post "/api/admin/genres", headers: @auth_headers, params: {
          genre: {
            name: "Psychedelic Rock",
            parent_id: "invalid"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "Genre is not found!" ], res_errors["parent_id"]
      end
    end
    it "should fail: missing params" do
      assert_no_difference("Platform::Genre.count") do
        post "/api/admin/genres", headers: @auth_headers, params: {
          genre: {
            name: nil
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "must be filled", "size cannot be less than 2" ], res_errors["name"]
      end
    end
    it "should fail: genre already exists" do
      assert_no_difference("Platform::Genre.count") do
        post "/api/admin/genres", headers: @auth_headers, params: {
          genre: {
            name: "Art Rock"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "The genre (art-rock) already exists!" ], res_errors["name"]
      end
    end
  end

  describe "PUT update" do
    it "should pass" do
      put "/api/admin/genres/#{genre.id}", headers: @auth_headers, params: {
        genre: {
          description: "Experimental Rock Sound"
        }
      }

      assert_response :success
      assert_equal "Experimental Rock Sound", res_data["description"]
    end
    it "should fail: genre is not found" do
      put "/api/admin/genres/abc", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "Genre is not found!" ], res_errors["base"]
    end
  end

  describe "DELETE destroy" do
    it "should pass" do
      assert_difference "Platform::Genre.count", -1 do
        delete "/api/admin/genres/#{genre.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: genre is not found" do
      assert_no_difference "Platform::Genre.count" do
        delete "/api/admin/genres/abc", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Genre is not found!" ], res_errors["base"]
      end
    end
  end
end
