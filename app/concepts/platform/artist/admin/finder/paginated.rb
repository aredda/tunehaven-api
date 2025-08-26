# frozen_string_literal: true

module Platform::Artist::Admin::Finder
  class Paginated < ApplicationFinder
    filter_by :name, with: :apply_name

    def apply_name(entity, _attribute, value)
      entity.where("name ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
