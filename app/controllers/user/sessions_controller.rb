# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # POST    api/user/sign_in
  def create
    run User::Operation::SignIn do
      sign_in(:user, @model)

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
