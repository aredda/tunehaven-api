# frozen_string_literal: true

module Platform::Album::Admin::Finder
  class Base < ApplicationFinder
    filter_by :title, with: :apply_title
    filter_by :artist_name, with: :apply_artist_name

    def apply_title(entity, _attribute, value)
      entity.where("title ILIKE ?", "%#{value}%") if value.present?
    end

    def apply_artist_name(entity, _attribute, value)
      entity.joins(:artist).where("platform_albums_artists.name ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
