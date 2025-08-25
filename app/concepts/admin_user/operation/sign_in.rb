# frozen_string_literal: true

module AdminUser::Operation
  class SignIn < ApplicationOperation
    step Model(OpenStruct)
    step Contract::Build(constant: User::Form::SignIn)
    step Contract::Validate(key: :admin)
    step :find_user
    fall :fail_not_found, fail_fast: true
    step :validate_params, Output(:failure) => Id(:fail_not_found)

    def find_user(ctx, params:, **)
      ctx[:model] = AdminUser.find_by email: params.dig(:admin, :email)
    end

    def validate_params(_ctx, params:, model:, **)
      model.valid_password? params[:admin][:password]
    end

    def fail_not_found_message(_context) = "invalid email or password"
  end
end
