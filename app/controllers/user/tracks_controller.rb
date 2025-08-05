# frozen_string_literal: true

class User::TracksController < User::Controller
  # PUT   /api/user/tracks/:id/toggle_like
  def toggle_like
    run User::PlaylistTrack::Operation::ToggleLike do
      return render json: { success: true }, status: :ok
    end

    render json: { success: false, errors: @form.errors.messages }, status: :unprocessable_entity
  end
end
