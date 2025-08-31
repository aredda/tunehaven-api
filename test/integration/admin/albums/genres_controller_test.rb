require "test_helper"

class Admin::Albums::GenresControllerTest < AdminIntegrationTest
  let(:album) { platform_albums(:ok_computer) }
  let(:art_rock) { platform_genres(:art_rock) }

  describe "GET index" do
    it "should pass" do
      album.genres << [ art_rock ]

      get "/api/admin/albums/#{album.id}/genres", headers: @auth_headers

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal %w[id genre created_at updated_at], res_data.first.keys
    end
    it "should fail: album is not found" do
      get "/api/admin/albums/abc/genres", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Album is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      post "/api/admin/albums/#{album.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id ]
        }
      }

      assert_response :created
      assert_equal %w[id genre created_at updated_at], res_data.first.keys
      assert_equal "art_rock", res_data.first["genre"]["id"]
    end
    it "should fail: duplicate genres" do
      album.genres << [ art_rock ]

      post "/api/admin/albums/#{album.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id ]
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "This album is already associated with this genre: art_rock" ], res_errors["genre_ids"]
    end
    it "should fail: invalid input" do
      post "/api/admin/albums/#{album.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: "invalid"
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "must be an array" ], res_errors["genre_ids"]
    end
  end

  describe "DELETE destroy" do
    it "should pass" do
      album.genres << art_rock

      assert_difference -> { album.genre_relationships.count }, -1 do
        delete "/api/admin/albums/#{album.id}/genres/#{art_rock.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: album is not found" do
      assert_no_difference -> { Platform::ArtistGenre.count } do
        delete "/api/admin/albums/abc/genres/xyz", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Album is not found!" ], res_errors["base"]
      end
    end
    it "should fail: record is not found" do
      assert_no_difference -> { Platform::ArtistGenre.count } do
        assert_no_difference -> { Platform::ArtistGenre.count } do
          delete "/api/admin/albums/#{album.id}/genres/xyz", headers: @auth_headers

          assert_response :unprocessable_content
          assert_equal [ "Record is not found!" ], res_errors["base"]
        end
      end
    end
  end
end
