# frozen_string_literal: true

require "test_helper"

class User::GenresControllerTest < UserIntegrationTest
  describe "GET index" do
    it "should pass" do
      get "/api/user/genres", headers: @auth_headers

      assert_response :success
      assert_equal %w[ id name description ], res_data.first.keys
    end
  end
end
