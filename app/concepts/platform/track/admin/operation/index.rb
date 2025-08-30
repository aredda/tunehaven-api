# frozen_string_literal: true

module Platform::Track::Admin::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Track::Admin::Finder::Base, :all, Platform::Track.order(created_at: :desc))
  end
end
