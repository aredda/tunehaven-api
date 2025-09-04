# frozen_string_literal: true

module Platform::Album::Operation
  class Show < ApplicationOperation
    step Model::Find(Platform::Album, find_by: :id)
    fall :fail_not_found, fail_fast: true

    def fail_not_found_message(_) = "Album is not found!"
  end
end
