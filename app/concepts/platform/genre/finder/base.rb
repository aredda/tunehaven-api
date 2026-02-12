# frozen_string_literal: true

module Platform::Genre::Finder
  class Base < Trailblazer::Finder
    adapter :ActiveRecord

    filter_by :q, with: :apply_q

    def apply_q(entity, _attribute, value)
      entity.where("name ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
