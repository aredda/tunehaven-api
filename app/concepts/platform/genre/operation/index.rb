# frozen_string_literal: true

module Platform::Genre::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Genre::Finder::Base, :all, Platform::Genre.order(name: :asc))
  end
end
