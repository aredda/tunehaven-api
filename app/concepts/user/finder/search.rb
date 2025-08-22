# frozen_string_literal: true

module User::Finder
  class Search < ApplicationFinder
    filter_by :query, with: :apply_query

    def apply_query(entity, _attr, value)
      if value.present?
        column_name = "title"
        column_name = "name" if entity == Platform::Artist

        entity.where("#{column_name} LIKE ?", "%#{value}%")
      end
    end
  end
end
