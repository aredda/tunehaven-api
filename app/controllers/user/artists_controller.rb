# frozen_string_literal: true

class User::ArtistsController < User::Controller
  # GET   /api/user/artists
  def index
    run Platform::Artist::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        data: Platform::Artist::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET   /api/user/artists/{id}
  def show
    run Platform::Artist::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Artist::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end
end
