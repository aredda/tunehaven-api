# frozen_string_literal: true

module Helpers
  module TitleFormatter
    NUMBERED_TITLE_REGEX = /^\d{1,2}\s*[.-]\s*/i

    def cleanse_title(raw)
      if raw.match? NUMBERED_TITLE_REGEX
        separator = "."
        separator = "-" if raw.include?("-")

        return raw.split(separator)[1].strip
      end

      raw
    end

    def dissect_title(raw)
      if raw.match? NUMBERED_TITLE_REGEX
        separator = "."
        separator = "-" if raw.include?("-")

        array = raw.split(separator)

        return { title: array[1].strip, order: Integer(array[0]) }
      end

      { title: raw, order: nil }
    end
  end
end
