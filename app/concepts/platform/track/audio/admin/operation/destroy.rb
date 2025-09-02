# frozen_string_literal: true

module Platform::Track::Audio::Admin::Operation
  class Destroy < FetchTrack
    step :find_audio
    fall ->(_, **) { fail_error(_, "Audio is not found!") }, fail_fast: true
    step ->(_, model:, **) { !model.is_master }
    fall ->(_, **) { fail_error(_, "Cannot delete a master audio!") }, fail_fast: true
    step ->(_, model:, **) { model.destroy }

    def find_audio(context, model:, params:, **)
      context[:model] = model.audios.find_by(id: params[:id])
    end
  end
end
