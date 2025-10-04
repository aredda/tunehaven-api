# frozen_string_literal: true

require "test_helper"

class Admin::DashboardControllerTest < AdminIntegrationTest
  describe "GET stats" do
    it "should pass" do
      get "/api/admin/dashboard/stats", headers: @auth_headers

      assert_response :success
      assert_equal %w[genres artists albums tracks users audios], res_data.keys
      assert_equal 2, res_data["genres"]
      assert_equal 3, res_data["artists"]
      assert_equal 2, res_data["albums"]
      assert_equal 4, res_data["tracks"]
      assert_equal 0, res_data["users"]
      assert_equal 0, res_data["audios"]
    end
  end
end
