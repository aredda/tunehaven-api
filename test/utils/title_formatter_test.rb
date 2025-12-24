# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require_relative "../../config/environment"
require "minitest/autorun"

class TitleFormatterTest < Minitest::Test
  include ::Helpers::TitleFormatter

  def test_cleanse_title
    target = "01. Airbag"

    assert_equal "Airbag", cleanse_title(target)
  end

  def test_skip_cleansing
    target = "Airbag"

    assert_equal "Airbag", cleanse_title(target)
  end
end
