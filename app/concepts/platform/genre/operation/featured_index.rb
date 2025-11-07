# frozen_string_literal: true

module Platform::Genre::Operation
  class FeaturedIndex < ApplicationOperation
    step :fetch_featured

    def fetch_featured(context, **)
      context[:data] = Platform::Genre.where(featured: true).order(name: :asc)
    end
  end
end
