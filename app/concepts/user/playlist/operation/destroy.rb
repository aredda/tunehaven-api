# frozen_string_literal: true

module User::Playlist::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step :is_default?
    fall :fail_irremovable, fail_fast: true
    step :destroy

    def is_default?(_context, model:, **)
      !model.is_default
    end

    def fail_irremovable(context, **)
      fail_error(context, "This playlist is irremovable!")
    end

    def destroy(_context, model:, **) = model.destroy
  end
end
