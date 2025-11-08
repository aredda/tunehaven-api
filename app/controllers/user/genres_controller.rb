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

  # GET     /api/user/genres/:id
  def show
    run Platform::Genre::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Genre::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # GET     /api/user/genres/featured
  def featured
    run Platform::Genre::Operation::FeaturedIndex do |context|
      data = context[:data]

      render json: {
        success: true,
        data: Platform::Genre::View::Index.for_collection.new(data)
      }, status: :ok
    end
  end

  # GET     /api/user/genres/:id/albums
  def albums
    run Platform::Album::Operation::ByGenreIndex do |context|
      data = context[:finder].result

      return render json: {
        success: true,
        data: Platform::Album::View::Index.for_collection.new(data),
        meta: MetaView.new(data)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end
end
