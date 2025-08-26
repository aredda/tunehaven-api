# frozen_string_literal: true

class Admin::GenresController < Admin::Controller
  # GET     /api/admin/genres
  def index
    run Platform::Genre::Admin::Operation::Index do |context|
      result = context[:finder].result

      render json: {
        success: true,
        data: Platform::Genre::Admin::View::Index.for_collection.new(result),
        meta: MetaView.new(result)
      }, status: :ok
    end
  end

  # GET     /api/admin/genres/:id
  def show
    run Platform::Genre::Admin::Operation::Show do
      return render json: {
        success: true,
        data: Platform::Genre::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :not_found
  end

  # POST    /api/admin/genres
  def create
    run Platform::Genre::Admin::Operation::Create do
      return render json: {
        success: true,
        data: Platform::Genre::Admin::View::Index.new(@model)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # PUT     /api/admin/genres/:id
  def update
    run Platform::Genre::Admin::Operation::Update do
      return render json: {
        success: true,
        data: Platform::Genre::Admin::View::Show.new(@model)
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # DELETE  /api/admin/genres/:id
  def destroy
    run Platform::Genre::Admin::Operation::Destroy do
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
