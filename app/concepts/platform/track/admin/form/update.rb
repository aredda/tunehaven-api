# frozen_string_literal: true

module Platform::Track::Admin::Form
  class Update < ApplicationForm
    property :title
    property :duration_in_seconds
  end
end
