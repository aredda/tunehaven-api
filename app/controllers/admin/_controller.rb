# frozen_string_literal: true

class Admin::Controller < ApplicationController
  before_action :authenticate_admin!

  private

  def _run_options(options)
    super.merge!(current_admin: current_admin)
  end
end
