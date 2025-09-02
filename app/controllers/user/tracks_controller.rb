# frozen_string_literal: true

class User::TracksController < User::Controller
  # GET   /api/user/tracks
  def index
    run User::PlaylistTrack::Operation::DefaultIndex do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: User::PlaylistTrack::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }
    end
  end

  # GET   /api/user/tracks/:id
  def show
    run Platform::Track::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Track::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # GET   /api/user/tracks/:id/stream
  def stream
    run Platform::Track::Operation::Stream do
      return send_file "public/#{@model.file.url}", type: "audio/#{@model.format}", disposition: "inline"
    end

    head :not_found
  end

  # PUT   /api/user/tracks/:id/toggle_like
  def toggle_like
    run User::PlaylistTrack::Operation::ToggleLike do
      return render json: { success: true }, status: :ok
    end

    render json: { success: false, errors: @form.errors.messages }, status: :unprocessable_content
  end
end
