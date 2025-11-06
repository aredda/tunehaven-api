# frozen_string_literal: true

require "test_helper"

class User::LibraryControllerTest < UserIntegrationTest
  let(:album) { platform_albums(:ok_computer) }

  describe "GET recent" do
    it "should pass" do
      Fabricate.times(2, :user_playlist_save, user: @user)
      @user.saved_albums << album

      get "/api/user/library/recent", headers: @auth_headers

      assert_response :success
      assert_equal 3, res_data.count
      assert_equal %w[ id type collection ], res_data.first.keys
    end
  end
end
