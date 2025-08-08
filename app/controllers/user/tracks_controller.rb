# frozen_string_literal: true

class User::TracksController < User::Controller
  # GET   /api/user/tracks
  def index
    run User::PlaylistTrack::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: User::PlaylistTrack::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }
    end
  end

  # PUT   /api/user/tracks/:id/toggle_like
  def toggle_like
    run User::PlaylistTrack::Operation::ToggleLike do
      return render json: { success: true }, status: :ok
    end

    render json: { success: false, errors: @form.errors.messages }, status: :unprocessable_entity
  end
end
