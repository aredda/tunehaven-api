# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Create < ApplicationOperation
    step Model(Platform::Track, :new)
    step Contract::Build(constant: Platform::Track::Admin::Form::Create)
    step Contract::Validate(key: :track)
    step Contract::Persist()
  end
end
