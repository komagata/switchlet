# frozen_string_literal: true

module Switchlet
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/switchlet.rake"
    end
  end
end
