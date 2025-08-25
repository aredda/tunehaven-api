# == Schema Information
#
# Table name: admin_user_jwt_deny_lists
#
#  id  :bigint           not null, primary key
#  exp :datetime         not null
#  jti :string           not null
#
# Indexes
#
#  index_admin_user_jwt_deny_lists_on_jti  (jti)
#
class AdminUser::JwtDenyList < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
end
