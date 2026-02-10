# frozen_string_literal: true

class AddCountersToUsersTable < ActiveRecord::Migration[8.0]
  def change
    change_table :users, bulk: true do |table|
      table.column :public_playlists_count, :integer, default: 0
      table.column :followers_count, :integer, default: 0
      table.column :following_count, :integer, default: 0
    end
  end
end
