# frozen_string_literal: true

module User::PlaylistTrack::Operation
  class DefaultShow < ApplicationOperation
    step :find_model
    fall :fail_not_found

    def find_model(context, params:, **)
      context[:model] = Platform::Track.find_by(id: params[:id])
    end

    def fail_not_found_message(_context) = "Track is not found!"
  end
end
