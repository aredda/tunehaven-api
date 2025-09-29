# frozen_string_literal: true

class Admin::AlbumsController < Admin::Controller
  # GET     /api/admin/albums
  def index
    run Platform::Album::Admin::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Album::Admin::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET     /api/admin/albums/autocomplete
  def autocomplete
    run Platform::Album::Admin::Operation::Autocomplete do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Album::Admin::View::Autocomplete.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET     /api/admin/albums/:id
  def show
    run Platform::Album::Admin::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Album::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST    /api/admin/albums
  def create
    run Platform::Album::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::Album::Admin::View::Index.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT     /api/admin/albums/:id
  def update
    run Platform::Album::Admin::Operation::Update do
      return render json: {
        success: true,
        data: Platform::Album::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/admin/albums/:id
  def destroy
    run Platform::Album::Admin::Operation::Destroy do
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
