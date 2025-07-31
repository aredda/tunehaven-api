# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.citext :username, null: false
      t.citext :email, null: false
      t.string :password, null: false
      t.string :state, null: true

      t.index :email, unique: true

      t.timestamps
    end
  end
end
