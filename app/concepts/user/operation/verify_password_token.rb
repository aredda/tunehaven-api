# frozen_string_literal: true

module User::Operation
  class VerifyPasswordToken < ApplicationOperation
    step Model(OpenStruct, :new)
    step Contract::Build(constant: User::Form::VerifyToken)
    step Contract::Validate(), fail_fast: true
    step :find_user
    fall :fail_not_found

    def find_user(context, params:, **)
      context[:model] = User.where("reset_password_sent_at >= ?", 15.minutes.ago).find_by(reset_password_token: params[:token])
    end


    def fail_not_found_message(_context)
      "Invalid or expired token!"
    end
  end
end
