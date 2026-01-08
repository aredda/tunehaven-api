# frozen_string_literal: true

module Platform::Track::Operation
  class Download < Show
    step :find_download_quality_setting
    step :find_audio
    fall ->(_, **) { fail_error(_, "Audio is not found!") }

    def find_download_quality_setting(context, current_user:, **)
      context[:quality] = current_user.download_quality_setting.value
    end

    def find_audio(context, model:, quality:, **)
      context[:model] = model.audios.find_by(quality:)
    end
  end
end
