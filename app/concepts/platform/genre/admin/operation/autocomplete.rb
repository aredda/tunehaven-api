# frozen_string_literal: true

module Platform::Genre::Admin::Operation
  class Autocomplete < ApplicationOperation
    step Finder(Platform::Genre::Admin::Finder::Autocomplete, :all, Platform::Genre.select(:id, :name).order(name: :asc))
  end
end
