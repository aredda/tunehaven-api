require "test_helper"

class Admin::Tracks::GenresControllerTest < AdminIntegrationTest
  let(:track) { platform_tracks(:no_surprises) }
  let(:art_rock) { platform_genres(:art_rock) }

  describe "GET index" do
    it "should pass" do
      track.genres << [ art_rock ]

      get "/api/admin/tracks/#{track.id}/genres", headers: @auth_headers

      assert_response :success
      assert_equal 1, res_data.count
      assert_equal %w[id genre created_at updated_at], res_data.first.keys
    end
    it "should fail: track is not found" do
      get "/api/admin/tracks/abc/genres", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "Track is not found!" ], res_errors["base"]
    end
  end

  describe "POST create" do
    it "should pass" do
      post "/api/admin/tracks/#{track.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id ]
        }
      }

      assert_response :created
      assert_equal %w[id genre created_at updated_at], res_data.first.keys
      assert_equal "art-rock", res_data.first["genre"]["id"]
    end
    it "should fail: duplicate genres" do
      track.genres << [ art_rock ]

      post "/api/admin/tracks/#{track.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id ]
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "This track is already associated with this genre: art-rock" ], res_errors["genre_ids"]
    end
    it "should fail: invalid input" do
      post "/api/admin/tracks/#{track.id}/genres", headers: @auth_headers, params: {
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
      track.genres << art_rock

      assert_difference -> { track.genre_relationships.count }, -1 do
        delete "/api/admin/tracks/#{track.id}/genres/#{art_rock.id}", headers: @auth_headers

        assert_response :success
      end
    end
    it "should fail: track is not found" do
      assert_no_difference -> { Platform::TrackGenre.count } do
        delete "/api/admin/tracks/abc/genres/xyz", headers: @auth_headers

        assert_response :unprocessable_content
        assert_equal [ "Track is not found!" ], res_errors["base"]
      end
    end
    it "should fail: record is not found" do
      assert_no_difference -> { Platform::TrackGenre.count } do
        assert_no_difference -> { Platform::TrackGenre.count } do
          delete "/api/admin/tracks/#{track.id}/genres/xyz", headers: @auth_headers

          assert_response :unprocessable_content
          assert_equal [ "Record is not found!" ], res_errors["base"]
        end
      end
    end
  end
end
