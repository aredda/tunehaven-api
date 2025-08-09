# frozen_string_literal: true

module User::Playlist::Operation
  class Update < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step Contract::Build(constant: User::Playlist::Form::Update)
    step Contract::Validate(key: :playlist)
    step Contract::Persist()
  end
end
