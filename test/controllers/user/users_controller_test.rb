require "test_helper"

class User::UsersControllerTest < UserIntegrationTest
  describe "GET show" do
    it "should fail: user not found" do
      get "/api/user/users/xyz", headers: @auth_headers

      assert_response :not_found
      assert_equal [ "User is not found!" ], res_errors["base"]
    end
    it "should pass" do
      user = Fabricate(:user, username: "cool_kid")

      get "/api/user/users/#{user.id}", headers: @auth_headers

      assert_response :success
      assert_equal %(id username followers_count following_count playlists_count), res_data.keys
      assert_equal "cool_kid", res_data["name"]
    end
    it "should pass: own account" do
      get "/api/user/users/#{@user.id}", headers: @auth_headers

      assert_response :success
      assert_equal %(id username email followers_count following_count playlists_count), res_data.keys
    end
  end
end
