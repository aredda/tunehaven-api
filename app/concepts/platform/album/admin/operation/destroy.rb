# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Destroy < ApplicationOperation
    step Subprocess(Show), Output(:failure) => Track(:end)
    step ->(_, model:, **) { model.destroy }
  end
end
