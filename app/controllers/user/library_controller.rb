# frozen_string_literal: true

class User::LibraryController < User::Controller
  # GET   /api/user/library/recent
  def recent
    run User::Library::Operation::RecentIndex do |context|
      data = context[:data]

      render json: {
        success: true,
        data: User::Library::View::Index.for_collection.new(data)
      }, status: :ok
    end
  end
end
