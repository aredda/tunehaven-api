# frozen_string_literal: true

module Platform::Track::Operation
  class Stream < Show
    step :find_audio
    fall ->(_, **) { fail_error(_, "Audio is not found!") }

    def find_audio(context, model:, **)
      # TODO: should get the audio based on the network's signal
      context[:model] = model.audios.find_by(quality: :low) || model.master_audio
    end
  end
end
