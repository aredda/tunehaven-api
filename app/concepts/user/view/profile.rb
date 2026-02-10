# frozen_string_literal: true

module User::View
  class Profile < ApplicationView
    property :id
    property :username
    property :email, if: ->(represented:, **) { represented.id == Profile.user.id }
    property :followers_count
    property :following_count
    property :public_playlists_count
    property :created_at
  end
end
