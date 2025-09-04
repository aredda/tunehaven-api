# frozen_string_literal: true

module User::AlbumSave::Finder
  class Base < Trailblazer::Finder
    adapter :ActiveRecord
  end
end
