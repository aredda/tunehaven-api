# frozen_string_literal: true

require "test_helper"

class User::MeControllerTest < UserIntegrationTest
  describe "GET show" do
    it "should pass: get current user profile" do
      get "/api/user/me", headers: @auth_headers

      assert_response :success
      assert_equal @user.id, response.parsed_body["user"]["id"]
      assert_equal @user.username, response.parsed_body["user"]["username"]
    end
  end

  describe "GET followers" do
    it "should pass: get empty followers list" do
      get "/api/user/me/followers", headers: @auth_headers

      assert_response :success
      assert res_success?
      assert_equal [], res_data
    end

    it "should pass: get followers list" do
      follower1 = Fabricate(:user)
      follower2 = Fabricate(:user)

      follower1.follow(@user)
      follower2.follow(@user)

      get "/api/user/me/followers", headers: @auth_headers

      assert_response :success
      assert res_success?
      assert_equal 2, res_data.length

      follower_ids = res_data.map { |u| u["id"] }
      assert_includes follower_ids, follower1.id
      assert_includes follower_ids, follower2.id
    end
  end

  describe "GET following" do
    it "should pass: get empty following list" do
      get "/api/user/me/following", headers: @auth_headers

      assert_response :success
      assert res_success?
      assert_equal [], res_data
    end

    it "should pass: get following list" do
      following1 = Fabricate(:user)
      following2 = Fabricate(:user)

      @user.follow(following1)
      @user.follow(following2)

      get "/api/user/me/following", headers: @auth_headers

      assert_response :success
      assert res_success?
      assert_equal 2, res_data.length

      following_ids = res_data.map { |u| u["id"] }
      assert_includes following_ids, following1.id
      assert_includes following_ids, following2.id
    end
  end
end
