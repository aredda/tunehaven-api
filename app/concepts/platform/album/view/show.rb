# frozen_string_literal: true

module Platform::Album::View
  class Show < Index
    property :cover_url, getter: ->(represented:, **) { represented.cover.full.url }
    collection :tracks do
      property :id
      property :position
      property :title
      property :duration_in_seconds
      property :is_liked, exec_context: :decorator
      property :download_url, exec_context: :decorator

      def download_url
        quality = Show.user.download_quality_setting.value

        represented.audios.find_by(quality:)&.file_url
      end

      def is_liked = Show.user.likes_track?(represented)
    end
    collection :genres do
      property :id
      property :name
    end
  end
end
