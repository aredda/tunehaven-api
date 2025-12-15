# frozen_string_literal: true

namespace :seed do
  task artists: :environment do
    begin
      json = JSON.parse(File.read(Rails.root.join("db", "seed/artists.json")))
    rescue
      puts "Could not find artists.json"
    end

    count = 0

    ActiveRecord::Base.transaction do
      json.each do |artist|
        genres = Platform::Genre.where(id: artist["genre_ids"]).pluck(:id)

        Platform::Artist.create(
          name: artist["name"],
          about: artist["about"],
          genres:
        )

        count += 1
      end
    end

    puts "[Seeder] #{count} artist(s) inserted."
  end

  task albums: :environment do
    begin
      json = JSON.parse(File.read(Rails.root.join("db", "seed/albums.json")))
    rescue
      puts "Could not find albums.json"
    end

    count = 0

    ActiveRecord::Base.transaction do
      json.each do |album|
        if (artist = Platform::Artist.find_by(slug: album["artist_slug"]))
          Platform::Album.create!(
            title: album["title"],
            artist:,
            release_date: album["release_date"],
            slug: album["slug"]
          )

          count+=1
        end
      end
    end

    puts "[Seeder] #{count} album(s) inserted."
  end
end
