Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get '/auth/:provider/callback' => 'sessions#create'
  root 'sessions#new'
  get '*path' => 'sessions#new'
end
