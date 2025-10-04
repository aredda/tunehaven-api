# frozen_string_literal: true

module AdminUser::Dashboard::View
  class Stats < ApplicationView
    property :genres
    property :artists
    property :albums
    property :tracks
    property :users
    property :audios
  end
end
