# frozen_string_literal: true

module Switchlet
  class Engine < Rails::Engine
    isolate_namespace Switchlet

    config.generators do |g|
      g.test_framework :minitest
      g.assets false
      g.helper false
    end
  end
end
