# frozen_string_literal: true

module Platform::AlbumGenre::Admin::Operation
  class Destroy < ApplicationOperation
    step Model::Find(Platform::Album, find_by: :id, params_key: :album_id)
    fall :fail_not_found, fail_fast: true
    step :find_model
    fall :fail_model_not_found
    step ->(_context, model:, **) { model.destroy }

    def find_model(context, model:, params:, **)
      context[:model] = model.genre_relationships.find_by(genre_id: params[:id])
    end

    def fail_model_not_found(context, **)
      fail_error(context, "Record is not found!")
    end

    def fail_not_found_message(_context)
      "Album is not found!"
    end
  end
end
