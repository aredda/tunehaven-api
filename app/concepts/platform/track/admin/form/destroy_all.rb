# frozen_string_literal: true

module Platform::Track::Admin::Form
  class DestroyAll < ApplicationForm
    property :track_ids

    validation do
      params do
        required(:track_ids).filled(:array?)
      end

      rule(:track_ids) do
        value.each do |id|
          key.failure("Could not find a track [#{id}]") unless Platform::Track.exists?(id:)
        end
      end
    end
  end
end
