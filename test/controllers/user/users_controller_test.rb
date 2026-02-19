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
      assert_equal %w[id username followers_count following_count public_playlists_count created_at], res_data.keys
      assert_equal "cool_kid", res_data["username"]
    end
    it "should pass: own account" do
      get "/api/user/users/#{@user.id}", headers: @auth_headers

      assert_response :success
      assert_equal %w[id username email followers_count following_count public_playlists_count created_at], res_data.keys
    end
  end

  describe "POST follow" do
    let(:target_user) { Fabricate(:user, followers_count: 0, following_count: 0) }

    it "should pass: follow user" do
      post "/api/user/users/#{target_user.id}/follow", headers: @auth_headers

      assert_response :created

      @user.reload
      target_user.reload

      assert_equal 1, @user.following_count
      assert_equal 1, target_user.followers_count
    end

    it "should fail: user not found" do
      post "/api/user/users/xyz/follow", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "User is not found" ], res_errors["base"]
    end

    it "should fail: follow self" do
      post "/api/user/users/#{@user.id}/follow", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "A user cannot follow himself" ], res_errors["base"]
    end

    it "should fail: already following" do
      @user.follow(target_user)

      post "/api/user/users/#{target_user.id}/follow", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "You are already following this user" ], res_errors["base"]
    end
  end

  describe "DELETE unfollow" do
    let(:target_user) { Fabricate(:user, followers_count: 0, following_count: 0) }

    it "should pass: unfollow user" do
      # First create a follow relationship
      @user.follow(target_user)

      delete "/api/user/users/#{target_user.id}/unfollow", headers: @auth_headers

      assert_response :success

      @user.reload
      target_user.reload

      assert_equal 0, @user.following_count
      assert_equal 0, target_user.followers_count
    end

    it "should fail: user not found" do
      delete "/api/user/users/xyz/unfollow", headers: @auth_headers

      assert_response :unprocessable_content
      assert_equal [ "User is not found" ], res_errors["base"]
    end

    it "should pass: not following" do
      delete "/api/user/users/#{target_user.id}/unfollow", headers: @auth_headers

      assert_response :success
    end
  end
end
