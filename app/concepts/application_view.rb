# frozen_string_literal: true

class ApplicationView < Representable::Decorator
  feature Representable::JSON
end

class MetaView < ApplicationView
  property :total_pages
  property :current_page
  property :next_page
  property :prev_page
end
