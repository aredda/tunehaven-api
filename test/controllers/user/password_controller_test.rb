# frozen_string_literal: true

require "test_helper"

class User::PasswordControllerTest < ActionDispatch::IntegrationTest
  let(:user) { Fabricate(:user) }

  describe "POST forget" do
    it "should fail: email not found" do
      post "/api/user/password/forget", params: {
        email: "brando@gmail.com"
      }

      assert_response :unprocessable_content
      assert_equal [ "Can't find a user that goes by this email!" ], res_errors["email"]
    end
    it "should pass" do
      post "/api/user/password/forget", params: {
        email: user.email
      }

      assert_response :success
      assert_predicate user.reload.reset_password_token, :present?
      assert_predicate user.reset_password_sent_at, :present?
    end
  end

  describe "GET verify" do
    it "should verify the reset password token" do
      user.send_reset_password_instructions

      get "/api/user/password/verify", params: {
        token: user.reload.reset_password_token
      }

      assert_response :success
    end
    it "should fail: invalid token" do
      user.send_reset_password_instructions
      user.update reset_password_sent_at: 1.day.ago

      get "/api/user/password/verify", params: {
        token: user.reload.reset_password_token
      }

      assert_response :unprocessable_content
      assert_equal [ "Invalid or expired token!" ], res_errors["base"]
    end
  end

  describe "POST reset" do
    it "should fail: invalid token" do
      post "/api/user/password/reset", params: {
        token: "XXAAZZ",
        password: "12345678"
      }

      assert_response :unprocessable_content
      assert_equal [ "Invalid or expired token!" ], res_errors["base"]
    end
    it "should fail: expired token" do
      user.send_reset_password_instructions
      user.update reset_password_sent_at: 1.day.ago

      post "/api/user/password/reset", params: {
        token: user.reset_password_token,
        password: "12345678"
      }

      assert_response :unprocessable_content
      assert_equal [ "Invalid or expired token!" ], res_errors["base"]
    end
    it "should fail: invalid password" do
      user.send_reset_password_instructions

      post "/api/user/password/reset", params: {
        token: user.reload.reset_password_token,
        password: "123"
      }

      assert_response :unprocessable_content
      assert_equal [ "size cannot be less than 8" ], res_errors["password"]
    end
    it "should pass" do
      user.send_reset_password_instructions

      post "/api/user/password/reset", params: {
        token: user.reload.reset_password_token,
        password: "12345678"
      }

      assert_response :success

      post "/api/user/sign_in", params: {
        user: {
          email: user.email,
          password: "12345678"
        }
      }

      assert_response :success
    end
  end
end
