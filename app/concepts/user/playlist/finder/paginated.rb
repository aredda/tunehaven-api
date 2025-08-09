# frozen_string_literal: true

module User::Playlist::Finder
  class Paginated < ApplicationFinder
    filter_by :title, with: :apply_title

    def apply_title(entity, _attr, value)
      entity.where("title LIKE ?", "%#{value}%") if value.present?
    end
  end
end
