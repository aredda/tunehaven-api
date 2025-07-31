# == Schema Information
#
# Table name: user_jwt_denylists
#
#  id  :bigint           not null, primary key
#  exp :datetime         not null
#  jti :string           not null
#
# Indexes
#
#  index_user_jwt_denylists_on_jti  (jti)
#
require "test_helper"

class User::JwtDenylistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
