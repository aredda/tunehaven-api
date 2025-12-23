require "test_helper"

class Admin::Logs::StorageSubEventsControllerTest < AdminIntegrationTest
  describe "GET index" do
    it "should get all logs" do
      2.times do
        Platform::Log::StorageSubEvent.create
      end

      get "/api/admin/logs/storage_sub_events", headers: @auth_headers

      assert_response :success
      assert_equal 2, res_data.count
    end
  end
end
