# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module Switchlet
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def create_migration_file
        migration_template "create_switchlet_flags.rb", "db/migrate/create_switchlet_flags.rb"
      end

      def create_initializer_file
        copy_file "switchlet.rb", "config/initializers/switchlet.rb"
      end
    end
  end
end
