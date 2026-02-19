# frozen_string_literal: true

module Concerns::SearchSanitizer
  private

  def sanitize_search_query(value)
    return value if value.is_a?(String) && value.match?(/\A[a-zA-Z0-9\s\-_]+\z/)
    ""
  end
end
