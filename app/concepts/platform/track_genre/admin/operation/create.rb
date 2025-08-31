# frozen_string_literal: true

module Platform::TrackGenre::Admin::Operation
  class Create < ApplicationOperation
    step Model::Find(Platform::Track, find_by: :id, params_key: :track_id)
    fall :fail_not_found
    step :build_model
    step Contract::Build(constant: Platform::TrackGenre::Admin::Form::Create)
    step Contract::Validate(key: :relationship)
    step :persist

    def fail_not_found_message(_context)
      "Track is not found!"
    end

    def build_model(context, model:, **)
      context[:model] = OpenStruct.new({ track: model })
    end

    def persist(context, model:, **)
      context[:model] = context["contract.default"].genre_ids.map do |genre_id|
        model.track.genre_relationships.create(genre_id:)
      end
    end
  end
end
