# frozen_string_literal: true

module Platform::Track::Audio::Admin::Operation
  class Create < FetchTrack
    step :build_model
    step Contract::Build(constant: Platform::Track::Audio::Admin::Form::Create)
    step Contract::Validate(key: :audio)
    step Contract::Persist()
    fall :fail_model_errors

    def build_model(context, model:, **)
      context[:model] = model.audios.build
    end

    def fail_model_errors(context, model:, **)
      context["contract.default"].errors.add(:file, model.errors.messages[:file])
    end
  end
end
