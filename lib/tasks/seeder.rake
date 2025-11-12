# frozen_string_literal: true

namespace :seed do
  task artists: :all do
    begin
      json = JSON.parse(File.read(Rails.root.join("db", "seed/artists.json")))
    rescue
      puts "Could not find artists.json"
    end

    ActiveRecord::Base.transaction do
      Platform::Artist.create(json)
    end
  end
end
