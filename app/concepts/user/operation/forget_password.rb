# frozen_string_literal: true

module User::Operation
  class ForgetPassword < ApplicationOperation
    step Model(OpenStruct)
    step Contract::Build(constant: User::Form::ForgetPassword)
    step Contract::Validate()
    step :find_user
    step :send_reset_password_instructions

    def find_user(context, params:, **)
      context[:model] = User.find_by([ "email ILIKE ?", params[:email] ])
    end

    def send_reset_password_instructions(_, model:, **)
      model.send_reset_password_instructions
    end
  end
end
