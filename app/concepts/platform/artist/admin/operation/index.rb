# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Index < ApplicationOperation
    step Finder(Platform::Artist::Admin::Finder::Paginated, :all, Platform::Artist.order(created_at: :desc))
  end
end
