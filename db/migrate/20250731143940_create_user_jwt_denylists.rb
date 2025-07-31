# frozen_string_literal: true

class CreateUserJwtDenylists < ActiveRecord::Migration[8.0]
  def change
    create_table :user_jwt_denylists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.index :jti
    end
  end
end
