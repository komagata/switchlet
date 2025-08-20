# frozen_string_literal: true

module Switchlet
  class FlagsController < ApplicationController
    def index
      @flags = Switchlet.list
    end


    def create
      flag_name = params[:flag_name].strip
      description = params[:description]&.strip
      if flag_name.present?
        Switchlet.enable!(flag_name, description: description)
        redirect_to switchlet.flags_path, notice: "Flag '#{flag_name}' created and enabled"
      else
        redirect_to switchlet.flags_path, alert: "Flag name cannot be empty"
      end
    end

    def update
      flag_name = params[:name]
      
      # Handle toggle action
      if params[:action_type] == 'toggle'
        current_state = Switchlet.enabled?(flag_name)
        
        if current_state
          Switchlet.disable!(flag_name)
        else
          Switchlet.enable!(flag_name)
        end
        
        redirect_to switchlet.flags_path, notice: "Flag '#{flag_name}' #{current_state ? 'disabled' : 'enabled'}"
      # Handle description update
      else
        description = params[:description]
        Switchlet.update!(flag_name, description: description)
        redirect_to switchlet.flags_path, notice: "Description updated for '#{flag_name}'"
      end
    end

    def destroy
      flag_name = params[:name]
      Switchlet.delete!(flag_name)
      redirect_to switchlet.flags_path, notice: "Flag '#{flag_name}' deleted"
    end
  end
end