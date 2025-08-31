# frozen_string_literal: true

class Admin::Albums::GenresController < Admin::Controller
  # GET       /api/admin/albums/:album_id/genres
  def index
    run Platform::AlbumGenre::Admin::Operation::Index do |context|
      result = context[:finder].result

      return render json: {
        success: true,
        data: Platform::AlbumGenre::Admin::View::Index.for_collection.new(result)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST      /api/admin/albums/:album_id/genres
  def create
    run Platform::AlbumGenre::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::AlbumGenre::Admin::View::Index.for_collection.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE    /api/admin/albums/:album_id/genres/:id
  def destroy
    run Platform::AlbumGenre::Admin::Operation::Destroy do
      return render json: {
        success: true
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
