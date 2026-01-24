# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Good Job Dashboard
  mount GoodJob::Engine => "good_job"

  scope :api, defaults: { format: :json }, format: false do
    devise_for :users,
               path: "/user",
               controllers: {
                 sessions: "user/sessions",
                 passwords: "user/passwords"
               }
    devise_for :admins, class_name: AdminUser, path: "/admin",
               controllers: { sessions: "admin/sessions", passwords: "admin/passwords" }

    resource :home, controller: :home, only: :show

    draw(:user)
    draw(:admin)
  end
end
