# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user

    mail to: user.email, subject: "Welcome to Tunehaven"
  end

  def forgot_password(user)
    @user = user

    mail to: user.email, subject: "Reset your password for Tunehaven"
  end
end
