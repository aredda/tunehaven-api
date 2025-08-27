# frozen_string_literal: true

module Platform::ArtistGenre::Admin::Operation
  class Create < ApplicationOperation
    step Model::Find(Platform::Artist, find_by: :id, params_key: :artist_id)
    fall :fail_not_found
    step :build_model
    step Contract::Build(constant: Platform::ArtistGenre::Admin::Form::Create)
    step Contract::Validate(key: :relationship)
    step :persist

    def fail_not_found_message(_context)
      "Artist is not found!"
    end

    def build_model(context, model:, **)
      context[:model] = OpenStruct.new({ artist: model })
    end

    def persist(context, model:, **)
      context[:model] = context["contract.default"].genre_ids.map do |genre_id|
        model.artist.genre_relationships.create(genre_id:)
      end
    end
  end
end
