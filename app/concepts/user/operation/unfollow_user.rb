# frozen_string_literal: true

module User::Operation
  class UnfollowUser < ApplicationOperation
    step Model::Find(User, find_by: :id)
    fall :fail_not_found, fail_fast: true
    pass :unfollow_target

    def unfollow_target(ctx, current_user:, model:, **)
      ctx[:result] = current_user.unfollow(model)
    end

    def fail_not_found_message(_context)
      "User is not found"
    end
  end
end
