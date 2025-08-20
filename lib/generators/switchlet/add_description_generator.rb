# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module Switchlet
  module Generators
    class AddDescriptionGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def create_migration_file
        migration_template "add_description_to_switchlet_flags.rb", "db/migrate/add_description_to_switchlet_flags.rb"
      end
    end
  end
end