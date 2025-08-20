# frozen_string_literal: true

Switchlet::Engine.routes.draw do
  root "flags#index"

  resources :flags, only: [:index, :create, :update, :destroy], param: :name
end
