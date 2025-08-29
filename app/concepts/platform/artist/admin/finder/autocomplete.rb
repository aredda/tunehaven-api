# frozen_string_literal: true

module Platform::Artist::Admin::Finder
  class Autocomplete < ApplicationFinder
    filter_by :q, with: :apply_q

    def apply_q(entity, _attr, value)
      entity.where("name ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
