# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Update < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step Contract::Build(constant: Platform::Artist::Admin::Form::Update)
    step Contract::Validate(key: :artist)
    step Contract::Persist()
  end
end
