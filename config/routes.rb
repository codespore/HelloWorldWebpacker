Rails.application.routes.draw do
  get '/calendar', to: 'calendar#index'
  root to: 'home#index'
end
