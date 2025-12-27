# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../../config/environment"
require "minitest/autorun"

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
  end

  def test_skip_cleansing
    target = "Airbag"

    assert_equal "Airbag", cleanse_title(target)
  end
end
