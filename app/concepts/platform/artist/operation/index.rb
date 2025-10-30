# frozen_string_literal: true

module Platform::Artist::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Artist::Finder::Base, :all, Platform::Artist.order(name: :asc))
  end
end
