# frozen_string_literal: true

module Platform::Track::Admin::Finder
  class Base < ApplicationFinder
    filter_by :title, with: :apply_title
    filter_by :album_title, with: :apply_album_title
    filter_by :artist_name, with: :apply_artist_name

    def apply_title(entity, _attribute, value)
      entity.where("platform_tracks.title ILIKE ?", "%#{value}%") if value.present?
    end

    def apply_artist_name(entity, _attribute, value)
      entity.joins(:artist).where("name ILIKE ?", "%#{value}%") if value.present?
    end

    def apply_album_title(entity, _attribute, value)
      entity.joins(:album).where("platform_albums.title ILIKE ?", "%#{value}%") if value.present?
    end
  end
end
