# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Transcode < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step :has_audio?
    fall :fail_not_found, fail_fast: true
    step :transcode

    def has_audio?(_context, model:, **)
      model.master_audio.present?
    end

    def fail_not_found_message(_context)
      "This track has no attached master audio!"
    end

    def transcode(_context, model:, **)
      Platform::Track::Audio::TranscodeJob.perform_later(model.master_audio)
    end
  end
end
