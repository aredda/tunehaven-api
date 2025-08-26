# frozen_string_literal: true

module Platform::Genre::Admin::Operation
  class Show < ApplicationOperation
    step Model::Find(Platform::Genre, find_by: :id)
    fall :fail_not_found

    def fail_not_found_message(_context)
      "Genre is not found!"
    end
  end
end
