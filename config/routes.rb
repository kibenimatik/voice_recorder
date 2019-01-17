# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recordings, only: %w[index destroy]
  root to: 'application#home'
  post 'upload' => 'application#upload', as: :generate_image
  get 'r5t' => 'application#r5t'
  get 'dyno' => 'application#dyno', as: :dyno
end
