# frozen_string_literal: true

class User::AlbumsController < User::Controller
  # GET   /api/user/albums
  def index
    run User::AlbumSave::Operation::Index do |context|
      result = context[:finder].result

      return render json: {
        success: true,
        data: Platform::Album::View::Index.for_collection.new(result)
      }, status: :ok
    end
  end

  # GET   /api/user/albums/:id
  def show
    run Platform::Album::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Album::View::Show.with_options(current_user:).new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST    /api/user/albums/:id/toggle_save
  def toggle_save
    run Platform::Album::Operation::ToggleSave do
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
