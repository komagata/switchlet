# frozen_string_literal: true

class AddDescriptionToSwitchletFlags < ActiveRecord::Migration[6.1]
  def change
    add_column :switchlet_flags, :description, :text
  end
end