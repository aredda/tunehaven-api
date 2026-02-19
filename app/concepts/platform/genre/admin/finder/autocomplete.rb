# frozen_string_literal: true

module Platform::Genre::Admin::Finder
  class Autocomplete < ApplicationFinder
    
    property :q

    filter_by :q, with: :apply_q

    def apply_q(entity, _attribute, value)
      return unless value.present?
      
      sanitized_value = sanitize_search_query(value)
      
      entity.where("name ILIKE ?", "%#{sanitized_value}%") if sanitized_value.present?
    end

  end
end
