# frozen_string_literal: true

require "test_helper"

class Musicbrainz::ReleaseGroupTest < Minitest::Test
  def test_find_by
    responses = [
      {
        "count" => 1,
        "release-groups" => [
          { "id" => "rg-1", "title" => "OK Computer", "first-release-date" => "1997-05-21" }
        ]
      },
      { "genres" => [ { "name" => "alternative rock" } ] }
    ]

    stub_method(Faraday, :new, fake_client(responses)) do
      release = Musicbrainz::ReleaseGroup.find_by(artist: "Radiohead", title: "OK Computer")

      assert_equal "rg-1", release.id
      assert_equal "OK Computer", release.title
      assert_equal "1997-05-21", release.release_date
      assert_equal [ "alternative rock" ], release.genres
    end
  end

  def test_not_found
    stub_method(Faraday, :new, fake_client([ { "count" => 0, "release-groups" => [] } ])) do
      release = Musicbrainz::ReleaseGroup.find_by(artist: "INVALID ARTIST", title: "INVALID ALBUM")

      assert_nil release
    end
  end

  private

  def fake_client(responses)
    queue = responses.dup

    Object.new.tap do |client|
      client.define_singleton_method(:get) do |_path|
        OpenStruct.new(body: JSON.generate(queue.shift))
      end
    end
  end
end
