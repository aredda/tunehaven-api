# frozen_string_literal: true

module User::Playlist::Form
  class Create < ApplicationForm
    property :title, type: Types::StrippedString
    property :description

    validation do
      params do
        required(:title).filled
        optional(:description)
      end
    end
  end
end
