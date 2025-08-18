# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "active_record"

# Setup test database
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

# Create the test table
ActiveRecord::Migration.create_table :switchlet_flags do |t|
  t.string  :name,    null: false
  t.boolean :enabled, null: false, default: false
  t.timestamps
end
ActiveRecord::Migration.add_index :switchlet_flags, :name, unique: true

require "switchlet"
