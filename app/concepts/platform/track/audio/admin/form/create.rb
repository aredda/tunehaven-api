# frozen_string_literal: true

module Platform::Track::Audio::Admin::Form
  class Create < ApplicationForm
    property :file

    validation do
      params do
        required(:file).filled
      end
    end
  end
end
