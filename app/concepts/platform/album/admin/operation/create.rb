# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Create < ApplicationOperation
    step Model(Platform::Album, :new)
    step Contract::Build(constant: Platform::Album::Admin::Form::Create)
    step Contract::Validate(key: :album)
    step Contract::Persist()
    fall :fail_model_errors

    def fail_model_errors(context, model:, **)
      context["contract.default"].errors.add(:cover, model.errors.messages[:cover]) if model.errors.messages.key?(:cover)
    end
  end
end
