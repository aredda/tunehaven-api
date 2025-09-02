# frozen_string_literal: true

module User::Form
  class Create < ApplicationForm
    property :email, type: Types::StrippedString
    property :username, type: Types::StrippedString
    property :password

    validation do
      params do
        required(:email).filled(format?: VALID_EMAIL_REGEX)
        required(:username).filled(min_size?: 6)
        required(:password).filled(min_size?: 8)
      end

      rule(:email) do
        key.failure("This email is already taken!") if User.exists?([ "email ILIKE ?", value ])
      end

      rule(:username) do
        key.failure("This username is already taken!") if User.exists?(username: value)
      end
    end
  end
end
