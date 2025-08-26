# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Create < ApplicationOperation
    step Model(Platform::Artist, :new)
    step Contract::Build(constant: Platform::Artist::Admin::Form::Create)
    step Contract::Validate(key: :artist)
    step Contract::Persist()
  end
end
