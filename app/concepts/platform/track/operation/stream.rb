# frozen_string_literal: true

module Platform::Track::Operation
  class Stream < Show
    step :find_audio
    step :find_quality_setting
    fall ->(_, **) { fail_error(_, "Audio is not found!") }

    def find_quality_setting(context, current_user:, **)
      context[:quality] = current_user.quality_setting&.value || :low
    end

    def find_audio(context, model:, quality:, **)
      context[:model] = model.audios.find_by(quality:)
    end
  end
end
