# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Update < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step Contract::Build(constant: Platform::Track::Admin::Form::Update)
    step Contract::Validate(key: :track)
    step Contract::Persist()
  end
end
