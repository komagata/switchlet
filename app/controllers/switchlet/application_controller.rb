# frozen_string_literal: true

module Switchlet
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_switchlet_access!

    private

    def authenticate_switchlet_access!
      config = Switchlet.configuration

      # 1. Check custom authentication block (highest priority)
      if config.authenticate_block?
        return if instance_exec(self, &config.authenticate_block)
        render_access_denied
        return
      end

      # 2. Check IP restriction
      unless config.ip_allowed?(request.remote_ip)
        render_access_denied("IP address not allowed")
        return
      end

      # 3. Check Basic authentication
      if config.basic_auth_configured?
        authenticate_or_request_with_http_basic("Switchlet Admin") do |username, password|
          username == config.basic_auth_username && password == config.basic_auth_password
        end
      end
    end

    def render_access_denied(message = "Access denied")
      if request.format.html?
        render html: <<~HTML.html_safe, status: :forbidden
          <!DOCTYPE html>
          <html>
          <head>
            <title>Access Denied</title>
            <style>
              body { font-family: Arial, sans-serif; text-align: center; margin-top: 100px; }
              .error { color: #e74c3c; }
            </style>
          </head>
          <body>
            <h1 class="error">🚫 Access Denied</h1>
            <p>#{message}</p>
            <p>You don't have permission to access Switchlet admin interface.</p>
          </body>
          </html>
        HTML
      else
        render json: { error: message }, status: :forbidden
      end
    end
  end
end