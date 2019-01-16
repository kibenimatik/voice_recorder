# frozen_string_literal: true

Rails.application.routes.draw do
  resources :recordings, only: %w[index destroy]
  root to: 'application#home'
  post 'upload' => 'application#upload', as: :generate_image
end
