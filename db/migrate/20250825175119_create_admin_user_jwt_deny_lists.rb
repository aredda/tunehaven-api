# frozen_string_literal: true

class CreateAdminUserJwtDenyLists < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_user_jwt_deny_lists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.index :jti
    end
  end
end
