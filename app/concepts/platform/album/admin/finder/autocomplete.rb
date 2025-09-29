# frozen_string_literal: true

module Platform::Album::Admin::Finder
  class Autocomplete < ApplicationFinder
    property :q

    filter_by :q, with: :apply_q

    def apply_q(entity, _attribute, value)
      entity.where("title ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
