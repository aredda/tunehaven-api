# frozen_string_literal: true

module Platform::Genre::Admin::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Genre::Admin::Finder::Base, :all, Platform::Genre.order(name: :asc))
  end
end
