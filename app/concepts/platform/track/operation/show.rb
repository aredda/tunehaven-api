# frozen_string_literal: true

module Platform::Track::Operation
  class Show < ApplicationOperation
    step Model::Find(Platform::Track, find_by: :id)
    fall :fail_not_found, fail_fast: true

    def fail_not_found_message(_context)
      "Track is not found!"
    end
  end
end
