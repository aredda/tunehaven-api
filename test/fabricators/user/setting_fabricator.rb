# frozen_string_literal: true

Fabricator :user_setting, class_name: "User::Setting" do
  key { Faker::Lorem.words(number: 3).join.parameterize }
  value { Faker::Lorem.word }
end
