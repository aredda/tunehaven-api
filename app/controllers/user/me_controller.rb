# frozen_string_literal: true

class User::MeController < User::Controller
  # GET   /api/user
  def show
    render json: {
      success: true,
      user: User::View::Session.new(current_user)
    }, status: :ok
  end
end
