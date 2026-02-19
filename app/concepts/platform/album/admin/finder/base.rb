# frozen_string_literal: true

module Platform::Album::Admin::Finder
  class Base < ApplicationFinder
    
    filter_by :title, with: :apply_title
    filter_by :artist_name, with: :apply_artist_name

    def apply_title(entity, _attribute, value)
      return unless value.present?
      
      sanitized_value = sanitize_search_query(value)
      
      entity.where("title ILIKE ?", "%#{sanitized_value}%") if sanitized_value.present?
    end

    def apply_artist_name(entity, _attribute, value)
      return unless value.present?
      
      sanitized_value = sanitize_search_query(value)
      
      entity.joins(:artist).where("name ILIKE ?", "%#{sanitized_value}%") if sanitized_value.present?
    end

  end
end
