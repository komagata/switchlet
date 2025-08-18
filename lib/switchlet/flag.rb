# frozen_string_literal: true

module Switchlet
  class Flag < ActiveRecord::Base
    self.table_name = "switchlet_flags"

    validates :name, presence: true, uniqueness: true
  end
end