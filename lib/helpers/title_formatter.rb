# frozen_string_literal: true

module Helpers
  module TitleFormatter
    SEPARATED_TITLE_REGEX = /^\d{1,2}\s*[.-]\s*/i
    BARE_TITLE_REGEX = /^0?\d+\s+.+$/i

    def cleanse_title(raw)
      unless raw.include?("-") || raw.include?(".")
        if raw.match? BARE_TITLE_REGEX
          separator = " "

          result = raw.split(separator)
          number = result.first
          result.delete_at 0

          return [ number.strip, result.join(separator).strip ]
        end
      end

      if raw.match? SEPARATED_TITLE_REGEX
        separator = "."
        separator = "-" if raw.include?("-")

        result = raw.split(separator)

        return [ result.first.strip, result.second.strip ]
      end

      raw
    end

    def dissect_title(raw)
      if raw.match?(SEPARATED_TITLE_REGEX) || raw.match?(BARE_TITLE_REGEX)
        number, title = cleanse_title raw

        return { title:, order: number.to_i }
      end

      { title: raw, order: nil }
    end
  end
end
