# frozen_string_literal: true

module Platform::Track::Admin::View
  class Show < Index
    property :album do
      property :id
      property :slug
      property :title
      property :cover_url, getter: ->(represented:, **) { represented.cover.full.url }
    end
  end
end
