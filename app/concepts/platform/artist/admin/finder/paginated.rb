# frozen_string_literal: true

module Platform::Artist::Admin::Finder
  class Paginated < ApplicationFinder
    filter_by :name, with: :apply_name

    def apply_name(entity, _attribute, value)
      return unless value.present?
      
      sanitized_value = sanitize_search_query(value)
      
      entity.where("name ILIKE ?", "%#{sanitized_value}%") if sanitized_value.present?
    end

  end
end
