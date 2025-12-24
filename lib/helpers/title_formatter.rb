# frozen_string_literal: true

module Helpers
  module TitleFormatter
    NUMBERED_TITLE_REGEX = /^\d{2}\./i

    def cleanse_title(raw)
      if raw.match? NUMBERED_TITLE_REGEX
        return raw.split(".")[1].strip
      end

      raw
    end
  end
end
