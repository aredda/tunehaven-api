# frozen_string_literal: true

module User::Operation
  class FollowUser < ApplicationOperation
    step Model::Find(User, find_by: :id)
    fall :fail_not_found, fail_fast: true
    step Rescue(StandardError, handler: :exception_handler) {
      step :follow_target
    }

    def follow_target(ctx, current_user:, model:, **)
      ctx[:model] = current_user.follow(model)
    end

    def fail_not_found_message(_context)
      "User is not found"
    end
  end
end
