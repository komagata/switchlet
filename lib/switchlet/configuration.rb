# frozen_string_literal: true

require "ipaddr"

module Switchlet
  class Configuration
    attr_accessor :basic_auth_enabled, :basic_auth_username, :basic_auth_password
    attr_accessor :allowed_ips
    attr_reader :authenticate_block

    def initialize
      @basic_auth_enabled = false
      @basic_auth_username = nil
      @basic_auth_password = nil
      @allowed_ips = []
      @authenticate_block = nil
    end

    def authenticate_with(&block)
      @authenticate_block = block
    end

    def authenticate_block?
      !@authenticate_block.nil?
    end

    def basic_auth_configured?
      basic_auth_enabled && basic_auth_username && basic_auth_password
    end

    def ip_allowed?(ip_address)
      return true if allowed_ips.empty?

      allowed_ips.any? do |allowed_ip|
        if allowed_ip.include?("/")
          IPAddr.new(allowed_ip).include?(ip_address)
        else
          IPAddr.new(allowed_ip).include?(IPAddr.new(ip_address))
        end
      end
    rescue IPAddr::InvalidAddressError
      false
    end
  end
end