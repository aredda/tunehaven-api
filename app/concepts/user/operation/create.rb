# frozen_string_literal: true

module User::Operation
  class Create < ApplicationOperation
    step Model(User, :new)
    step Contract::Build(constant: User::Form::Create)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    pass :send_welcome_email

    def send_welcome_email(_context, model:, **)
      UserMailer.welcome(model).deliver_later
    end
  end
end
