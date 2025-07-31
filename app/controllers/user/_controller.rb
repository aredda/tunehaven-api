# frozen_string_literal: true

class User::Controller < ApplicationController
  before_action :authenticate_user!

  private

  def _run_options(options)
    super.merge!(current_user: current_user)
  end
end
