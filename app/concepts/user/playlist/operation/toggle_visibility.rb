# frozen_string_literal: true

module User::Playlist::Operation
  class ToggleVisibility < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step :is_default?
    fall :fail_cannot_toggle_visibility, fail_fast: true
    step :toggle_visibility

    def is_default?(_options, model:, **)
      !model.is_default
    end

    def fail_cannot_toggle_visibility(options, **)
      fail_error(options, "Cannot share your Liked Tracks playlist to the public!")
    end

    def toggle_visibility(_options, model:, **)
      model.toggle_visibility
    end
  end
end
