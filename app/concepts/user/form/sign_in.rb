# frozen_string_literal: true

class User::Form::SignIn < ApplicationForm
  property :email, type: Types::StrippedString
  property :password

  validation do
    params do
      required(:email).filled
      required(:password).filled
    end
  end
end
