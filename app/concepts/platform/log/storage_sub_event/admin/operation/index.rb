# frozen_string_literal: true

module Platform::Log::StorageSubEvent::Admin::Operation
  class Index < ApplicationOperation
    step Finder(ApplicationFinder, :all, Platform::Log::StorageSubEvent)
  end
end
