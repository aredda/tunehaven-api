# frozen_string_literal: true

module User::Form
  class ResetPassword < ApplicationForm
    property :token, types: Types::StrippedString
    property :password

    validation do
      params do
        required(:token).filled
        required(:password).filled(min_size?: 8)
      end
    end
  end
end
