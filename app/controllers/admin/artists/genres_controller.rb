# frozen_string_literal: true

class Admin::Artists::GenresController < Admin::Controller
  # GET       /api/admin/artists/:artist_id/genres
  def index
    run Platform::ArtistGenre::Admin::Operation::Index do |context|
      result = context[:finder].result

      return render json: {
        success: true,
        data: Platform::ArtistGenre::Admin::View::Index.for_collection.new(result)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST      /api/admin/artists/:artist_id/genres
  def create
    run Platform::ArtistGenre::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::ArtistGenre::Admin::View::Index.for_collection.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE    /api/admin/artists/:artist_id/genres/:id
  def destroy
    run Platform::ArtistGenre::Admin::Operation::Destroy do
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
