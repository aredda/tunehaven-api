# frozen_string_literal: true

require "test_helper"

class Musicbrainz::ReleaseGroupTest < Minitest::Test
  def test_default
    release = Musicbrainz::ReleaseGroup.find_by(artist: "Radiohead", title: "OK Computer")

    assert_equal "OK Computer", release.title
    assert_equal "1997-05-21", release.release_date
    assert release.genres.length > 0
    assert_includes release.genres, "alternative rock"
  end

  def test_not_found
    release = Musicbrainz::ReleaseGroup.find_by artist: "INVALID ARTIST", title: "INVALID ALBUM"

    assert_nil release
  end
end
