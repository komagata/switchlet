# frozen_string_literal: true

Switchlet::Engine.routes.draw do
  root "flags#index"

  resources :flags, only: %i[index create update destroy], param: :name
end
