# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  # POST    api/admin/sign_in
  def create
    run AdminUser::Operation::SignIn do
      sign_in(:admin, @model)

      return render json: {
        success: true,
        token: current_token
      }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unauthorized
  end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
