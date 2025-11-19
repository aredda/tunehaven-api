# frozen_string_literal: true

class Admin::TracksController < Admin::Controller
  # GET   /api/admin/tracks
  def index
    run Platform::Track::Admin::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Track::Admin::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET   /api/admin/tracks/:id
  def show
    run Platform::Track::Admin::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Track::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # GET   /api/admin/tracks/:id/stream
  def stream
    run Platform::Track::Operation::Stream do
      return send_file @model.file_url, type: "audio/#{@model.format}", disposition: "inline"
    end

    head :not_found
  end

  # POST  /api/admin/tracks
  def create
    run Platform::Track::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::Track::Admin::View::Index.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT   /api/admin/tracks/:id
  def update
    run Platform::Track::Admin::Operation::Update do
      return render json: {
        success: true,
        data: Platform::Track::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT   /api/admin/tracks/:id/move/:position
  def move
    run Platform::Track::Admin::Operation::Move do
      return render json: {
        success: true,
        data: Platform::Track::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT     /api/admin/tracks/:id/transcode
  def transcode
    run Platform::Track::Admin::Operation::Transcode do
      return render json: {
        success: true
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_entity
  end


  # DELETE  /api/admin/tracks/:id
  def destroy
    run Platform::Track::Admin::Operation::Destroy do
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
