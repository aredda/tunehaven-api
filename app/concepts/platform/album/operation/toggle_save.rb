# frozen_string_literal: true

module Platform::Album::Operation
  class ToggleSave < Show
    step :find_album_save
    fall :save_album, Output(:success) => End(:success)
    step :unsave_album

    def find_album_save(context, current_user:, model:, **)
      context[:model] = current_user.album_saves.find_by(likable_id: model.id)
    end

    def save_album(_, current_user:, params:, **)
      current_user.album_saves.create(likable_id: params[:id])
    end

    def unsave_album(_, model:, **)
      model.destroy
    end
  end
end
