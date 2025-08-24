# frozen_string_literal: true

# Switchlet configuration
Switchlet.configure do |_config|
  # === Custom Authentication (Recommended) ===
  # Integrate with your existing authentication system
  # This takes highest priority over other authentication methods

  # Example 1: Devise + admin role
  # config.authenticate_with do |controller|
  #   controller.authenticate_user! && controller.current_user.admin?
  # end

  # Example 2: CanCanCan authorization
  # config.authenticate_with do |controller|
  #   controller.authorize! :manage, :switchlet
  # end

  # Example 3: Custom session-based authentication
  # config.authenticate_with do |controller|
  #   controller.session[:admin_logged_in] == true
  # end

  # === Basic Authentication ===
  # Simple username/password authentication using environment variables
  # Only used if no custom authentication block is set

  # config.basic_auth_enabled = Rails.env.production?
  # config.basic_auth_username = ENV['SWITCHLET_USERNAME']
  # config.basic_auth_password = ENV['SWITCHLET_PASSWORD']

  # === IP Restriction ===
  # Allow access only from specific IP addresses
  # Supports both single IPs and CIDR notation
  # Works in combination with other authentication methods

  # config.allowed_ips = [
  #   '127.0.0.1',          # localhost
  #   '10.0.0.0/8',         # private network
  #   '192.168.1.0/24'      # local network
  # ]

  # === Development Settings ===
  # In development, you might want to disable authentication entirely
  unless Rails.env.development?
    # Enable authentication in staging/production
    # Choose one of the methods above
  end
end
