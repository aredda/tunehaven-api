# frozen_string_literal: true

class User::SettingsController < User::Controller
  # GET   /api/user/settings
  def index
    run User::Setting::Operation::Index do
      return render json: {
        success: true,
        data: User::Setting::View::Index.for_collection.new(@model)
      }, status: :ok
    end
  end

  # POST  /api/user/settings
  def create
    run User::Setting::Operation::Create do
      return render json: {
        success: true,
        data: User::Setting::View::Index.for_collection.new(current_user.settings)
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
