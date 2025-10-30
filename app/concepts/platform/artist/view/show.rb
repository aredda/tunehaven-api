# frozen_string_literal: true

module Platform::Artist::View
  class Show < Index
    property :about

    collection :genres do
      property :id
      property :name
    end

    collection :albums, decorator: Platform::Album::View::Index.with_options(**Show.options)
  end
end
