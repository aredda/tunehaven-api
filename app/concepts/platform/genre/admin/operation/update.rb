# frozen_string_literal: true

module Platform::Genre::Admin::Operation
  class Update < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step Contract::Build(constant: Platform::Genre::Admin::Form::Update)
    step Contract::Validate(key: :genre)
    step Contract::Persist()
  end
end
