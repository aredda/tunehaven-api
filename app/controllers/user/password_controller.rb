# frozen_string_literal: true

class User::PasswordController < ApplicationController
  # POST    /api/user/password/forget
  def forget
    run User::Operation::ForgetPassword do
      return render json: { success: true }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end


  # GET   /api/user/password/verify
  def verify
    run User::Operation::VerifyPasswordToken do
      return render json: { success: true }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end

  # POST    /api/user/password/reset
  def reset
    run User::Operation::ResetPassword do
      return render json: { success: true }, status: :ok
    end

    render json: {
      success: false,
      errors: @form.errors.messages
    }, status: :unprocessable_content
  end
end
