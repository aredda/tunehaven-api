# frozen_string_literal: true

module User::Library::Operation
  class RecentIndex < ApplicationOperation
    step :fetch_recent

    def fetch_recent(context, current_user:, **)
      context[:data] = current_user.likes.order(created_at: :desc).limit(5)
    end
  end
end
