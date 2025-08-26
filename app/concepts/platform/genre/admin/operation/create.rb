# frozen_string_literal: true

module Platform::Genre::Admin::Operation
  class Create < ApplicationOperation
    step Model(Platform::Genre, :new)
    step Contract::Build(constant: Platform::Genre::Admin::Form::Create)
    step Contract::Validate(key: :genre)
    step Contract::Persist()
  end
end
