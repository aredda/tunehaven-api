# frozen_string_literal: true

require "test_helper"

class TitleFormatterTest < Minitest::Test
  include ::Helpers::TitleFormatter

  def test_cleanse_title
    assert_equal "Airbag", cleanse_title("1. Airbag")
    assert_equal "Airbag", cleanse_title("02. Airbag")
    assert_equal "Airbag", cleanse_title("01- Airbag")
    assert_equal "Airbag", cleanse_title("10 - Airbag")
    assert_equal "Airbag", cleanse_title("8- Airbag")
    assert_equal "Airbag", cleanse_title("9 - Airbag")
  end

  def test_dissect_title
    assert_equal({ title: "Airbag", order: 1 }, dissect_title("1. Airbag"))
    assert_equal({ title: "Karma Police", order: 5 }, dissect_title("05 - Karma Police"))
    assert_equal({ title: "Karma Police", order: 8 }, dissect_title("08- Karma Police"))
    assert_equal({ title: "Karma Police", order: 9 }, dissect_title("09. Karma Police"))
    assert_equal({ title: "invalid. Karma Police", order: nil }, dissect_title("invalid. Karma Police"))
  end

  def test_dissect_and_insert
    album = Platform::Album.create(title: "Dummy", artist: Fabricate(:artist))

    [
      "04. Don’t Stop",
      "03. Never Going Back Again",
      "05. Go Your Own Way",
      "01. Second Hand News",
      "07. The Chain",
      "08. You Make Loving Fun",
      "09. I Don’t Want To Know",
      "11. Gold Dust Woman",
      "02. Dreams",
      "10. Oh Daddy",
      "06. Songbird"
    ].each do |raw|
      result = dissect_title raw

      track = Fabricate(:track, album:, title: result[:title])
      track.set_list_position(result[:order])
    end

    assert_equal [
                   [ 1, "Second Hand News" ],
                   [ 2, "Dreams" ],
                   [ 3, "Never Going Back Again" ],
                   [ 4, "Don’t Stop" ],
                   [ 5, "Go Your Own Way" ],
                   [ 6, "Songbird" ],
                   [ 7, "The Chain" ],
                   [ 8, "You Make Loving Fun" ],
                   [ 9, "I Don’t Want To Know" ],
                   [ 10, "Oh Daddy" ],
                   [ 11, "Gold Dust Woman" ]
                 ], album.tracks.order(position: :asc).pluck(:position, :title)
  end

  def test_skip_cleansing
    target = "Airbag"

    assert_equal "Airbag", cleanse_title(target)
  end
end
