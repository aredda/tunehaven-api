# frozen_string_literal: true

module Platform::Artist::Admin::View
  class Show < Index
    collection :albums do
      property :id
      property :slug
      property :title
      property :release_date
      property :tracks_count
      property :cover_url, getter: ->(represented:, **) { represented.cover.full.url }
    end
    collection :genres do
      property :id
      property :name
    end
  end
end
