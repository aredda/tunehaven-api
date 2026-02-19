# frozen_string_literal: true

module Platform::Genre::Finder
  class Base < Trailblazer::Finder
    include Concerns::SearchSanitizer

    adapter :ActiveRecord

    filter_by :q, with: :apply_q

    def apply_q(entity, _attribute, value)
      return unless value.present?

      sanitized_value = sanitize_search_query(value)

      entity.where("name ILIKE ?", "%#{sanitized_value}%") if sanitized_value.present?
    end
  end
end
