# frozen_string_literal: true

module User::Library::View
  class Index < ApplicationView
    property :id
    property :likable_type, as: :type
    property :likable, as: :collection, exec_context: :decorator

    def likable
      return Platform::Album::View::Index.new(represented.likable) if represented.likable_type == "Platform::Album"

      User::Playlist::View::Base.new(represented.likable)
    end
  end
end
