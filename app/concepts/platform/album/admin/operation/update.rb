# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Update < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step Contract::Build(constant: Platform::Album::Admin::Form::Update)
    step Contract::Validate(key: :album)
    step Contract::Persist()
  end
end
