# frozen_string_literal: true

module User::Form
  class VerifyToken < ApplicationForm
    property :token, types: Types::StrippedString

    validation do
      params do
        required(:token).filled
      end
    end
  end
end
