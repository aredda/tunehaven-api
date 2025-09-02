# frozen_string_literal: true

class User::RegistrationsController < ApplicationController
  # POST    /api/user/sign_up
  def create
    run User::Operation::Create do
      sign_in(:user, @model)

      return render json: {
        success: true,
        data: { token: }
      }, status: :created
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  def token
    request.env["warden-jwt_auth.token"]
  end
end
