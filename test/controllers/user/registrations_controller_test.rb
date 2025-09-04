# frozen_string_literal: true

require "test_helper"

class User::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  describe "POST create" do
    it "should fail: invalid params" do
      assert_no_difference "User.count" do
        post "/api/user/sign_up", params: {
          user: {
            email: "invalid email format",
            username: "bra",
            password: "12"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "is in invalid format" ], res_errors["email"]
        assert_equal [ "size cannot be less than 6" ], res_errors["username"]
        assert_equal [ "size cannot be less than 8" ], res_errors["password"]
      end
    end
    it "should fail: email is already taken" do
      Fabricate(:user, email: "brando@gmail.com")

      assert_no_difference "User.count" do
        post "/api/user/sign_up", params: {
          user: {
            email: "BRANDO@gmail.com",
            username: "brando",
            password: "12345678"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "This email is already taken!" ], res_errors["email"]
      end
    end
    it "should fail: username is already taken" do
      Fabricate(:user, username: "brando")

      assert_no_difference "User.count" do
        post "/api/user/sign_up", params: {
          user: {
            email: "brando@gmail.com",
            username: "brando",
            password: "12345678"
          }
        }

        assert_response :unprocessable_content
        assert_equal [ "This username is already taken!" ], res_errors["username"]
      end
    end
    it "should pass" do
      assert_difference "User.count", 1 do
        post "/api/user/sign_up", params: {
          user: {
            email: "brando@gmail.com",
            username: "brando",
            password: "12345678"
          }
        }

        assert_response :created
        assert res_data["token"].present?
        assert_not_empty res_data["token"]
      end
    end
  end
end
