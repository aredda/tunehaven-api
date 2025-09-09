# frozen_string_literal: true

module Platform::Track::Admin::Form
  class Move < ApplicationForm
    property :position, type: Types::IntegerType

    validation do
      params do
        required(:position).filled(gteq?: 1)
      end
    end
  end
end
