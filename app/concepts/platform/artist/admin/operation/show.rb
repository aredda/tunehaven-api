# frozen_string_literal: true

module Platform::Artist::Admin::Operation
  class Show < ApplicationOperation
    step :find_artist
    fall :fail_not_found

    def find_artist(context, params:, **)
      context[:model] = Platform::Artist.where(id: params[:id]).or(Platform::Artist.where(slug: params[:id])).first
    end

    def fail_not_found_message(_context)
      "Artist is not found!"
    end
  end
end
