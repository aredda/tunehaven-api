# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :citext           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  state                  :string
#  username               :citext           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
Fabricator :user, class_name: 'User' do
  username    { Faker::Name.name }
  email         { Faker::Internet.email }
  password      { Faker::Internet.password }
end
