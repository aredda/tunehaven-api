# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json

  include ActionController::MimeResponds
  include ActionController::RespondWith

  include Trailblazer::Rails::Controller

  include Devise::Controllers::Helpers
  include Devise::Controllers::UrlHelpers
end
