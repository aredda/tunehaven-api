# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Move < Show
    step :move_to_position

    def move_to_position(_, model:, params:, **)
      model.insert_at(params[:position].to_i)
    end
  end
end
