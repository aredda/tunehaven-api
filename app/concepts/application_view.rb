# frozen_string_literal: true

class ApplicationView < Representable::Decorator
  feature Representable::JSON

  defaults render_nil: true

  @options = {}

  class << self
    attr_reader :options

    def with_options(**options)
      @options = options

      self
    end
  end
end

class MetaView < ApplicationView
  property :total_pages
  property :current_page
  property :next_page
  property :prev_page
end
