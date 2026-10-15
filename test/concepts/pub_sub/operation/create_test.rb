# frozen_string_literal: true

require "test_helper"
require "google/cloud/storage"

class PubSub::Operation::CreateTest < ActiveSupport::TestCase
  Trailblazer::Test.module!(self)

  it "should fail" do
    notification = {
      message: OpenStruct.new({ data: JSON.generate({ name: "invalid", contentType: "" }) })
    }

    assert_fail PubSub::Operation::Create, { notification: OpenStruct.new(notification) }
    assert_equal 1, Platform::Log::StorageSubEvent.count
  end

  it "should pass" do
    notification = OpenStruct.new
    notification.message = OpenStruct.new
    notification.message.data = JSON.generate({ name: "uploads/library/Radiohead/The Bends/15. Fake Plastic Trees.flac", contentType: "audio/flac" })

    metadata = Musicbrainz::ReleaseGroup.new id: "rg-1", title: "The Bends", release_date: "1995-03-13"
    metadata.genres = [ "Alternative Rock" ]

    stub_method(Musicbrainz::ReleaseGroup, :find_by, metadata) do
      assert_difference -> { Platform::Track::Audio.count } do
        assert_difference -> { Platform::Track.count } do
          assert_pass PubSub::Operation::Create, { notification: } do |result|
            assert_equal "Fake Plastic Trees", result[:model].title
            assert_equal "The Bends", result[:model].album.title
            assert_equal "radiohead-the-bends", result[:model].album.slug
            assert_predicate result[:model].album.release_date, :present?
            assert_not_equal 0, result[:model].album.genres.count
            assert_includes result[:model].album.genres.pluck(:name), "Alternative Rock"
            assert_equal 15, result[:model].position
          end
        end
      end
    end
  end

  it "should upload the album cover" do
    skip

    notification = OpenStruct.new
    notification.message = OpenStruct.new
    notification.message.data = JSON.generate({
                                                name: "uploads/library/radiohead/kid-a/folder.jpg",
                                                contentType: "image/jpeg"
                                              })

    bucket = Google::Cloud::Storage.new.bucket ENV.fetch("GCS_BUCKET_NAME"), skip_lookup: true

    assert_pass PubSub::Operation::Create, { bucket:, notification: } do |result|
      album = Platform::Album.find_by slug: "radiohead-kid-a"

      assert_predicate album.cover, :present?
    end
  end
end
