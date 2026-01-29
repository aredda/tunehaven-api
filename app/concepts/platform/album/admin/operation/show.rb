# frozen_string_literal: true

module Platform::Album::Admin::Operation
  class Show < ApplicationOperation
    step :find_album
    fall :fail_not_found, fail_fast: true

    def find_album(context, params:, **)
      context[:model] = Platform::Album.where(id: params[:id]).or(Platform::Album.where(slug: params[:id])).first
    end

    def fail_not_found_message(_context)
      "Album is not found!"
    end
  end
end
