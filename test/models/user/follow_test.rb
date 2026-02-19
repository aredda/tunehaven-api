# frozen_string_literal: true

require "test_helper"

class User::FollowTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:follower).class_name("User")
    should belong_to(:following).class_name("User")
  end
end
