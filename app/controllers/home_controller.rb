# frozen_string_literal: true

class HomeController < User::Controller
  # GET   /api/home
  def show
    run User::Operation::Home do
      render json: { data: User::View::Home.new(@model) }, status: :ok
    end
  end
end
