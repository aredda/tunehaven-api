# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Show < ApplicationOperation
    step Model::Find(Platform::Artist, find_by: :id)
    fall :fail_not_found

    def fail_not_found_message(_context)
      "Artist is not found!"
    end
  end
end
