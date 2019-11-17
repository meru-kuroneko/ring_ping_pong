Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'ping_pong', to: 'ping_pong#index'
  root to: 'ping_pong#index'
end
