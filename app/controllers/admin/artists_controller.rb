# frozen_string_literal: true

class Admin::ArtistsController < Admin::Controller
  # GET   /api/admin/artists
  def index
    run Platform::Artist::Admin::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Artist::Admin::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET   /api/admin/artists/autocomplete
  def autocomplete
    run Platform::Artist::Admin::Operation::Autocomplete do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Artist::Admin::View::Autocomplete.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET   /api/admin/artists/:id
  def show
    run Platform::Artist::Admin::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Artist::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST  /api/admin/artists
  def create
    run Platform::Artist::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::Artist::Admin::View::Index.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT   /api/admin/artists/:id
  def update
    run Platform::Artist::Admin::Operation::Update do
      return render json: {
        success: true,
        data: Platform::Artist::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/admin/artists/:id
  def destroy
    run Platform::Artist::Admin::Operation::Destroy do
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
