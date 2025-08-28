# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Show < ApplicationOperation
    step Model::Find(Platform::Album, find_by: :id)
    fall :fail_not_found

    def fail_not_found_message(_context)
      "Album is not found!"
    end
  end
end
