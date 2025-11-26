# frozen_string_literal: true

require "test_helper"

class PubSub::Operation::CreateTest < ActiveSupport::TestCase
  Trailblazer::Test.module!(self)

  it "should fail" do
    notification = {
      message: OpenStruct.new({ data: JSON.generate({ name: "invalid", contentType: "" }) })
    }

    assert_fail PubSub::Operation::Create, { notification: OpenStruct.new(notification) } do |result|
      assert_equal [ "Failed to process this entry: invalid" ], result["contract.default"].errors.messages[:base]
    end
  end

  it "should pass" do
    notification = OpenStruct.new
    notification.message = OpenStruct.new
    notification.message.data = JSON.generate({ name: "uploads/library/Radiohead/The Bends/Fake Plastic Trees.flac", contentType: "audio/flac" })

    assert_difference -> { Platform::Track::Audio.count } do
      assert_difference -> { Platform::Track.count } do
        assert_pass PubSub::Operation::Create, { notification: } do |result|
          assert_equal "Fake Plastic Trees", result[:model].title
          assert_equal "The Bends", result[:model].album.title
          assert_equal "radiohead-the-bends", result[:model].album.slug
        end
      end
    end
  end
end
