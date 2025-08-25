# frozen_string_literal: true

class Admin::MeController < Admin::Controller
  # GET   /api/admin
  def show
    render json: {
      success: true,
      user: AdminUser::View::Session.new(current_admin)
    }, status: :ok
  end
end
