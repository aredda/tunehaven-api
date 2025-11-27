# frozen_string_literal: true

require "test_helper"

class User::SettingsControllerTest < UserIntegrationTest
  describe "GET index" do
    it "should pass" do
      Fabricate.times(3, :user_setting, user: @user)

      get "/api/user/settings", headers: @auth_headers

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[id key value], res_data.first.keys
    end
  end

  describe "POST create" do
    it "should fail: invalid input" do
      assert_no_difference -> { User::Setting.count } do
        post "/api/user/settings", headers: @auth_headers, params: {
          settings: [
            { wrong_key: "wrong key" }
          ]
        }

        assert_response :unprocessable_content
        assert_equal [ "Invalid input. Array should contain objects with a 'key' and a 'value' properties" ], res_errors["settings"]
      end
    end
    it "should pass" do
      assert_difference -> { User::Setting.count }, 2 do
        post "/api/user/settings", headers: @auth_headers, params: {
          settings: [
            { key: "quality", value: "original" },
            { key: "language", value: "english" }
          ]
        }

        assert_response :created
        assert_equal 2, res_data.count
        assert_equal %w[id key value], res_data.first.keys
      end

      # update existing settings
      assert_no_difference -> { User::Setting.count } do
        post "/api/user/settings", headers: @auth_headers, params: {
          settings: [
            { key: "quality", value: "low" },
            { key: "language", value: "french" }
          ]
        }

        assert_response :created
        assert_equal 2, res_data.count
        assert_equal %w[id key value], res_data.first.keys
        assert_equal "low", res_data.first["value"]
        assert_equal "french", res_data.second["value"]
      end
    end
  end
end
