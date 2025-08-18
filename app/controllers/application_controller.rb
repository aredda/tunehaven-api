# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :use_unsafe_params

  respond_to :json

  include ActionController::MimeResponds
  include ActionController::RespondWith

  include Trailblazer::Rails::Controller

  include Devise::Controllers::Helpers
  include Devise::Controllers::UrlHelpers

  def params
    @_dangerous_params || super
  end

  private

  def use_unsafe_params
    return unless self.class.method_defined?(:index)

    @_dangerous_params = request.parameters
  end
end
