# frozen_string_literal: true

module Platform::Genre::Admin::Finder
  class Autocomplete < ApplicationFinder
    property :q

    filter_by :q, with: :apply_q

    def apply_q(entity, _attribute, value)
      entity.where("name ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
