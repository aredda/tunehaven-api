# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < UserIntegrationTest
  describe "GET show" do
    let(:ok_computer) { platform_albums(:ok_computer) }
    let(:rumours) { platform_albums(:rumours) }

    it "should fail: unauthorized (missing headers)" do
      get "/api/home"

      assert_response :unauthorized
    end
    it "should pass" do
      @user.saved_albums << ok_computer

      # Make "Rumours" the most saved album
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)

      user1.saved_albums << rumours
      user2.saved_albums << rumours

      get "/api/home", headers: @auth_headers

      assert_response :success
      assert_equal %w[user_recent_saves most_album_saves], res_data.keys

      # User recent saves
      assert_equal 1, res_data["user_recent_saves"].count
      assert_equal "OK Computer", res_data["user_recent_saves"].first["collection"]["title"]

      # Most saved albums
      assert_equal 2, res_data["most_album_saves"].count
      assert_equal "Rumours", res_data["most_album_saves"].first["title"]
      assert_equal "OK Computer", res_data["most_album_saves"].second["title"]
    end
  end
end
