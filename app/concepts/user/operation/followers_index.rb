# frozen_string_literal: true

module User::Operation
  class FollowersIndex < ApplicationOperation
    step :get_followers

    def get_followers(ctx, current_user:, **)
      ctx[:model] = current_user.followers
    end
  end
end
