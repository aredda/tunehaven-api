# frozen_string_literal: true

class Admin::Tracks::AudiosController < Admin::Controller
  # GET     /api/admin/tracks/:track_id/audios
  def index
    run Platform::Track::Audio::Admin::Operation::Index do |context|
      result = context[:finder].result

      return render json: {
        success: true,
        data: Platform::Track::Audio::Admin::View::Index.for_collection.new(result)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST    /api/admin/tracks/:track_id/audios
  def create
    run Platform::Track::Audio::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::Track::Audio::Admin::View::Index.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/admin/tracks/:track_id/audios/:id
  def destroy
    run Platform::Track::Audio::Admin::Operation::Destroy do
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
