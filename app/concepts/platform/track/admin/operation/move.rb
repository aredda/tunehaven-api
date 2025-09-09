# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Move < ApplicationOperation
    step -> (context, params:, **) { context[:model] = OpenStruct.new(params) }
    step Contract::Build(constant: Platform::Track::Admin::Form::Move)
    step Contract::Validate()
    step Subprocess(Show), Output(:failure) => Track(:end)
    step :move_to_position

    def move_to_position(_, model:, params:, **)
      model.insert_at(params[:position].to_i)
    end
  end
end
