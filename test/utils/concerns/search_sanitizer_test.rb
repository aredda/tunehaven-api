# frozen_string_literal: true

require "test_helper"

class Concerns::SearchSanitizerTest < Minitest::Test
  class TestClass
    include Concerns::SearchSanitizer
  end

  def setup
    @sanitizer = TestClass.new
  end

  def test_sanitizes_safe_strings
    safe_string = "test-rock"
    result = @sanitizer.send(:sanitize_search_query, safe_string)
    assert_equal safe_string, result
  end

  def test_sanitizes_strings_with_spaces
    safe_string = "art rock"
    result = @sanitizer.send(:sanitize_search_query, safe_string)
    assert_equal safe_string, result
  end

  def test_sanitizes_strings_with_underscores
    safe_string = "test_rock"
    result = @sanitizer.send(:sanitize_search_query, safe_string)
    assert_equal safe_string, result
  end

  def test_blocks_sql_injection_attempts
    malicious_input = "'; DROP TABLE users; --"
    result = @sanitizer.send(:sanitize_search_query, malicious_input)
    assert_equal "", result
  end

  def test_blocks_non_string_input
    hash_input = { malicious: "input" }
    result = @sanitizer.send(:sanitize_search_query, hash_input)
    assert_equal "", result
  end

  def test_blocks_special_characters
    special_chars = "test@#$%^&*()"
    result = @sanitizer.send(:sanitize_search_query, special_chars)
    assert_equal "", result
  end
end
