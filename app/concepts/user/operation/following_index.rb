# frozen_string_literal: true

module User::Operation
  class FollowingIndex < ApplicationOperation
    step :get_following

    def get_following(ctx, current_user:, **)
      ctx[:model] = current_user.following
    end
  end
end
