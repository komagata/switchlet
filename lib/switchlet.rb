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

  def self.enable!(name)
    flag = Flag.find_or_create_by(name: name.to_s)
    flag.update!(enabled: true)
    true
  end

  def self.disable!(name)
    flag = Flag.find_or_create_by(name: name.to_s)
    flag.update!(enabled: false)
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
        updated_at: flag.updated_at
      }
    end
  end
end
