# frozen_string_literal: true

module Platform::Album::Admin::Form
  class Update < ApplicationForm
    property :title
    property :release_date
    property :cover
  end
end
