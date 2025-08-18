# frozen_string_literal: true

namespace :switchlet do
  desc "List all feature flags"
  task list: :environment do
    flags = Switchlet.list
    if flags.empty?
      puts "No feature flags found."
    else
      puts "Feature Flags:"
      flags.each do |flag|
        puts "  #{flag[:name]}: #{flag[:enabled]} (updated: #{flag[:updated_at]})"
      end
    end
  end

  desc "Enable a feature flag"
  task :enable, [:flag] => :environment do |_task, args|
    flag_name = args[:flag]
    abort "Please specify a flag name: rake switchlet:enable[flag_name]" if flag_name.blank?

    result = Switchlet.enable!(flag_name)
    puts "Flag '#{flag_name}' #{result ? 'enabled' : 'failed to enable'}."
  end

  desc "Disable a feature flag"
  task :disable, [:flag] => :environment do |_task, args|
    flag_name = args[:flag]
    abort "Please specify a flag name: rake switchlet:disable[flag_name]" if flag_name.blank?

    result = Switchlet.disable!(flag_name)
    puts "Flag '#{flag_name}' #{result ? 'already disabled' : 'disabled'}."
  end

  desc "Delete a feature flag"
  task :delete, [:flag] => :environment do |_task, args|
    flag_name = args[:flag]
    abort "Please specify a flag name: rake switchlet:delete[flag_name]" if flag_name.blank?

    Switchlet.delete!(flag_name)
    puts "Flag '#{flag_name}' deleted."
  end
end