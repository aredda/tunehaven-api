# frozen_string_literal: true

module Musicbrainz
  class ReleaseGroup
    attr_reader :id, :title, :release_date
    attr_accessor :genres

    def initialize(id:, title:, release_date:, **)
      @id = id
      @title = title
      @release_date = release_date
      @genres = []
    end

    def self.from_json(json)
      new id: json["id"], title: json["title"], release_date: json["first-release-date"]
    end

    class << self
      def find_by(artist:, title:, **)
        query = URI.encode_uri_component "query=artist:#{artist} AND releasegroup:#{title} AND primarytype:album AND NOT secondarytype:*"

        client = Faraday.new("https://musicbrainz.org/ws/2/", headers: {
          "Accept" => "application/json"
        }) do |f|
          f.request :digest, ENV.fetch("MUSICBRAINZ_USERNAME"), ENV.fetch("MUSICBRAINZ_PASSWORD")
          f.adapter Faraday.default_adapter
        end

        response = client.get "release-group/?query=#{query}"
        json = JSON.parse response.body

        return nil if json["count"].zero?

        release_group = from_json json["release-groups"].first

        response = client.get "release-group/#{release_group.id}?inc=genres"
        json = JSON.parse response.body

        release_group.genres = json["genres"].map { |row| row["name"] }

        release_group
      end
    end
  end
end
