# frozen_string_literal: true

module Platform::Album::View
  class Show < Index
    collection :tracks do
      property :id
      property :position
      property :title
      property :duration_in_seconds
      property :is_liked, exec_context: :decorator

      def is_liked = Show.user.likes_track?(represented)
    end
  end
end
