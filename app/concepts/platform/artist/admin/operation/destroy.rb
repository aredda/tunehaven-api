# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step ->(_context, model:, **) { model.destroy }
  end
end
