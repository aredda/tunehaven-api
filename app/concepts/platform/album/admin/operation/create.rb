# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Create < ApplicationOperation
    step Model(Platform::Album, :new)
    step Contract::Build(constant: Platform::Album::Admin::Form::Create)
    step Contract::Validate(key: :album)
    step Contract::Persist()
  end
end
