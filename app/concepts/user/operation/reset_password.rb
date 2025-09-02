# frozen_string_literal: true

module User::Operation
  class ResetPassword < ApplicationOperation
    step Model(OpenStruct, :new)
    step Contract::Build(constant: User::Form::ResetPassword)
    step Contract::Validate(), fail_fast: true
    step :find_user
    fall :fail_not_found
    step :reset_password

    def find_user(context, params:, **)
      context[:model] = User.where("reset_password_sent_at >= ?", 15.minutes.ago).find_by(reset_password_token: params[:token])
    end

    def reset_password(_, model:, params:, **)
      model.reset_password(params[:password])
    end

    def fail_not_found_message(_context)
      "Invalid or expired token!"
    end
  end
end
