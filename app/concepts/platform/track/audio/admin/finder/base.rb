# frozen_string_literal: true

module Platform::Track::Audio::Admin::Finder
  class Base < Trailblazer::Finder
    adapter :ActiveRecord
  end
end
