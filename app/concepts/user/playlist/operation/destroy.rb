# frozen_string_literal: true

module User::Playlist::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step :destroy

    def destroy(_context, model:, **) = model.destroy
  end
end
