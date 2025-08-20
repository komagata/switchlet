# frozen_string_literal: true

require_relative "switchlet/version"
require_relative "switchlet/flag"
require_relative "switchlet/configuration"
require_relative "switchlet/railtie" if defined?(Rails)
require_relative "switchlet/engine" if defined?(Rails)

module Switchlet
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.enabled?(name)
    Flag.find_by(name: name.to_s)&.enabled || false
  end

  def self.enable!(name, description: nil)
    flag = Flag.find_or_create_by(name: name.to_s)
    attrs = { enabled: true }
    attrs[:description] = description if description
    flag.update!(attrs)
    true
  end

  def self.disable!(name, description: nil)
    flag = Flag.find_or_create_by(name: name.to_s)
    attrs = { enabled: false }
    attrs[:description] = description if description
    flag.update!(attrs)
    false
  end

  def self.delete!(name)
    Flag.where(name: name.to_s).delete_all
    nil
  end

  def self.list
    Flag.order(:name).map do |flag|
      {
        name: flag.name,
        enabled: flag.enabled,
        description: flag.description,
        updated_at: flag.updated_at
      }
    end
  end

  def self.update!(name, description: nil, enabled: nil)
    flag = Flag.find_or_create_by(name: name.to_s)
    attrs = {}
    attrs[:description] = description unless description.nil?
    attrs[:enabled] = enabled unless enabled.nil?
    flag.update!(attrs) if attrs.any?
    flag
  end
end
