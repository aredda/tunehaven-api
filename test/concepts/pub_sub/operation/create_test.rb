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

    assert_difference -> { Platform::Track::Audio.count } do
      assert_difference -> { Platform::Track.count } do
        assert_pass PubSub::Operation::Create, { notification: } do |result|
          assert_equal "Fake Plastic Trees", result[:model].title
          assert_equal "The Bends", result[:model].album.title
          assert_equal "radiohead-the-bends", result[:model].album.slug
          assert_equal 15, result[:model].position
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
                                                contentType: "image/jpeg",
                                                mediaLink: "https://storage.googleapis.com/tunehaven-bucket/uploads/library/radiohead/kid-a/folder.jpg" })

    ENV["GOOGLE_CLOUD_CREDENTIALS"] = '{
      "type": "service_account",
      "project_id": "windy-container-481215-i2",
      "private_key_id": "58d345487d2483722a02cf2ae5f24b4fd1957eaf",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD1+1JhIq7JFrgM\ni+crocg90/o3jhgjqHgD2joFv543yYnzWiQFAYOBInqd7qtvvZYM6p17IWbgSy2d\n33DRr/OfUMvwBVP6gSkGQCE4qs1BHjENKjvcUpAJd6an0Hmm3fwV6HIsq257r/z0\nl4YB5GYmjsZxNjo6a/WZlz1O0VTuPRNbRTHuaF1gb8/CJNUW0lIXivJfh2UAVxP4\nesp6hc5mZu4hXwg30LBv/kWJNtUbVfi6aE/tKjfx8XTsOFzWPSI0RcPJYLq6L/Nx\nJgBD2IgpVBA8NpE79kK+0IWF3bWofh+Iz9OcZgHNta+N/NM4blBOHFRNIiLhJpaf\nBbNv2UDdAgMBAAECggEAD4eu23Z0Gzq1o10l2t8GTxkAtYc2xkbkT4yfQy5Q5UFy\ngIxoCm+JB5skq1nz4ER+TRHMStzWAO0zfmx//qJ25XpqwHGlrALW6I/Inn+cy91b\nHXNVf4MwQtjCCzBMre4FSgt4lzy6PKbkzTslI8jGxkJstvMZ2VxoOiqOnVj2sr/F\nYZwnSG06LgQgbck9rCWSh72vphAWFJsV6wDXHptppnMsH2A0Fo0mtwq76xWEW2qU\nxyzjUldFv5l2JLCT4gZHi1AIDr+ta9tPemca+BOcnKjJSiXhX2DjYUJ9jCKg7UIP\nVl4xB4SMQAfXXbORxSh8AerjwDMwl1fG/+yhim/MRQKBgQD7YwaY5YjSh0Hm0T62\nW1BvvayWCoTJByhb6QfJ87W4sAkdv6nWgzpY9YY58upt56uMmwsxd8S6Htp68ssY\nYluz0i68KgYlBPeqLzT5KciTOeykPOemkZCoZ1/4LFjDRDlcAhbXIRcvUm6ItxUa\nAjZ0qiyD+tLEWfjGtmblv0Z6IwKBgQD6fudd6Y5Ey7a9fhur8D9KRji6wx1zxsn2\nEeCL9I8a0JxPJCrnvnN9+Hi6cdmwNpkbcAsG9EbmuUweXZJFl0f6PGqYFVY+Svvm\nfRMImJfSxAyenI1fsC0MJ1qEe+3a3gKbnSYfQBUnCyRgYwaGyJFVUKUIXuopbkN3\nXqFk1eGI/wKBgQD04phwpVlNzNkT4s42kmmfEKRpXUHRGxnjvvQJdVGW4lVfF3B5\nOUjDlBn3pX1dJwtkYzzaKZQIwzmN/6p8zIQMfjlsr3tg4J/qtyXheySa1xiBPZtk\nFfVXN6yzc2/ceD9wM9DQLLoLLT/kCoWR2on1yDipMNPU1tiTqug98sDTBQKBgBJJ\nETqZwfjjpgNPIVX7w6L4XUvE0nGRIU0FIQ8WWxvp/n8IdNlV3bhkWuvBQ9LJKYQH\nOcbYLhTJkfTlf7f0wxxRLLbNV+5UKu84UhteiDaqeQFbDDbf9WndtY3WPhar/iS9\n4/qEAwdGmPEwSVmtam5/5Iwn4ZAErIgaME3cDwqhAoGBAOrzzyGbkz+HmNwoN1F/\nZMNo8JPAiyIcoIHNDqNFKhAUkBNZqHOhHVz/KEow+oQQ9ULebMlE152Rubqt+ZY4\n7RYQa9HLtz6AiGLqROLBqxJPyDSPdRRVd4YJwyRE0QvEq+T/N/BcZGqs27xNN6KO\nDVRbIya32SDVR+8hr3f9ogUl\n-----END PRIVATE KEY-----\n",
      "client_email": "admin-546@windy-container-481215-i2.iam.gserviceaccount.com",
      "client_id": "107631443784238691170",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/admin-546%40windy-container-481215-i2.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }'

    bucket = Google::Cloud::Storage.new.bucket "tunehaven-bucket", skip_lookup: true

    assert_pass PubSub::Operation::Create, { bucket:, notification: } do |result|
      album = Platform::Album.find_by slug: "radiohead-kid-a"

      assert_predicate album.cover, :present?
    end
  end
end
