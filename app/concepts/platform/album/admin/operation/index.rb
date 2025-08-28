# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Album::Admin::Finder::Base, :all, Platform::Album.order(created_at: :desc))
  end
end
