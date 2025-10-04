# frozen_string_literal: true

class Admin::DashboardController < Admin::Controller
  # GET     /api/admin/dashboard/stats
  def stats
    run AdminUser::Dashboard::Operation::Stats do |context|
      render json: {
        success: true,
        data: AdminUser::Dashboard::View::Stats.new(context[:model])
      }, status: :ok
    end
  end
end
