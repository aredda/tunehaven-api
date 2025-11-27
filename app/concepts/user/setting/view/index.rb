# frozen_string_literal: true

module User::Setting::View
  class Index < ApplicationView
    property :id
    property :key
    property :value
  end
end
