# frozen_string_literal: true

module Platform::Track::Audio::Admin::Form
  class Create < ApplicationForm
    property :file

    validation do
      params do
        required(:file).filled
      end

      rule(:file) do
        key.failure("Invalid file input.") unless value.is_a? ActionDispatch::Http::UploadedFile
      end
    end
  end
end
