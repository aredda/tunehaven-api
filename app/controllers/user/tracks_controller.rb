# frozen_string_literal: true

class User::TracksController < User::Controller
  before_action :authenticate_user!, except: :stream

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
        data: Platform::Track::View::Show.with_options(current_user:).new(@model)
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
      if Rails.env.test?
        return send_file @model.file_url, type: "audio/#{@model.format}", disposition: "inline"
      else
        redirect_to @model.file_url
      end
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

  # GET   /api/user/tracks/:id/playlists
  def playlists
    run User::Playlist::Operation::TrackIndex do |context|
      return render json: {
        success: true,
        data: User::Playlist::View::TrackIndex.with_options(track: @model).for_collection.new(context[:data])
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
