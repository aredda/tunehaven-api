# frozen_string_literal: true

class User::GenresController < User::Controller
  # GET     /api/user/genres
  def index
    run Platform::Genre::Operation::Index do |context|
      data = context[:finder].result

      render json: {
        success: true,
        data: Platform::Genre::View::Index.for_collection.new(data)
      }, status: :ok
    end
  end
end
