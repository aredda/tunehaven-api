# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Autocomplete < ApplicationOperation
    step Finder(Platform::Album::Admin::Finder::Autocomplete, :all, Platform::Album.select(:id, :title).order(title: :asc))
  end
end
