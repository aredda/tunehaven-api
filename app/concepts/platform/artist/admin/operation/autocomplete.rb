# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Autocomplete < ApplicationOperation
    step Finder(Platform::Artist::Admin::Finder::Autocomplete, :all, Platform::Artist.select(:id, :name).order(name: :asc))
  end
end
