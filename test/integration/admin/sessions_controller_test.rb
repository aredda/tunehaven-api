# frozen_string_literal: true

require "test_helper"

class AdminUser::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "#sign_in" do
    Fabricate(:admin, email: "brando@example.com", password: "12345678")

    # failure: invalid email
    post "/api/admin/sign_in", params: {
      admin: {
        email: "invalid_email",
        password: "invalid_password"
      }
    }

    assert_response :unauthorized
    assert_equal [ "invalid email or password" ], response.parsed_body["errors"]["base"]

    # failure: invalid password
    post "/api/admin/sign_in", params: {
      admin: {
        email: "brando@example.com",
        password: "invalid_password"
      }
    }

    assert_response :unauthorized
    assert_equal [ "invalid email or password" ], response.parsed_body["errors"]["base"]

    # success
    post "/api/admin/sign_in", params: {
      admin: {
        email: "brando@example.com",
        password: "12345678"
      }
    }

    assert_response :ok
    assert_not_nil response.parsed_body["token"]
  end

  test "#sign_out" do
    user = Fabricate(:admin, email: "brando@example.com", password: "12345678")
    headers = Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user, scope: :admin)

    # logged in
    post "/api/admin/sign_in", params: {
      admin: {
        email: "brando@example.com",
        password: "12345678"
      }
    }

    assert_response :ok
    assert_not_nil response.parsed_body["token"]

    get "/api/admin/me", headers: headers

    assert_response :success
    assert response.parsed_body["success"]
    assert_predicate response.parsed_body["user"], :present?

    # log out
    delete "/api/admin/sign_out", headers: headers

    assert_response :success

    # assert he is no longer logged in
    get "/api/admin/me", headers: headers

    assert_response :unauthorized
  end
end
