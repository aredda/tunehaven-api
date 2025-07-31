# frozen_string_literal: true

class User::Operation::SignIn < ApplicationOperation
  step Model(OpenStruct)
  step Contract::Build(constant: User::Form::SignIn)
  step Contract::Validate(key: :user)
  step :find_user
  fall :fail_not_found, fail_fast: true
  step :validate_params, Output(:failure) => Id(:fail_not_found)

  def find_user(ctx, params:, **)
    ctx[:model] = User.find_by email: params.dig(:user, :email)
  end

  def validate_params(_ctx, params:, model:, **)
    model.valid_password? params[:user][:password]
  end

  def fail_not_found_message(_context) = "invalid email or password"
end
