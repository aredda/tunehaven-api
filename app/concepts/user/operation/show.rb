# frozen_string_literal: true

module User::Operation
  class Show < ApplicationOperation
    step Model::Find(User, find_by: :id)
    fall :fail_not_found

    def fail_not_found_message(_context)
      "User is not found!"
    end
  end
end
