# frozen_string_literal: true

require "test_helper"

class Admin::Artists::GenresControllerTest < AdminIntegrationTest
  let(:artist) { platform_artists(:boston) }
  let(:art_rock) { platform_genres(:art_rock) }
  let(:indie_rock) { platform_genres(:indie_rock) }

  describe "POST create" do
    it "should pass" do
      post "/api/admin/artists/#{artist.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id ]
        }
      }

      assert_response :created
      assert_equal %w[id genre], res_data.first.keys
      assert_equal "art_rock", res_data.first["genre"]["id"]
    end
    it "should fail: duplicate genres" do
      artist.genres << [ art_rock, indie_rock ]

      post "/api/admin/artists/#{artist.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: [ art_rock.id, indie_rock.id ]
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "This artist is already associated with this genre: art_rock", "This artist is already associated with this genre: indie_rock" ], res_errors["genre_ids"]
    end
    it "should fail: invalid input" do
      post "/api/admin/artists/#{artist.id}/genres", headers: @auth_headers, params: {
        relationship: {
          genre_ids: "invalid"
        }
      }

      assert_response :unprocessable_content
      assert_equal [ "must be an array" ], res_errors["genre_ids"]
    end
  end
end
