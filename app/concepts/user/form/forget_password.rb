# frozen_string_literal: true

module User::Form
  class ForgetPassword < ApplicationForm
    property :email

    validation do
      params do
        required(:email).filled(format?: VALID_EMAIL_REGEX)
      end

      rule(:email) do
        key.failure("Can't find a user that goes by this email!") unless User.exists?([ "email ILIKE ?", value ])
      end
    end
  end
end
