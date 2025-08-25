# frozen_string_literal: true

Fabricator :admin, class_name: "AdminUser" do
  email         { Faker::Internet.email }
  password      { Faker::Internet.password }
end
