require 'sidekiq/web'

Draftin::Application.routes.draw do
  root 'default#index'
  get '/example' => 'default#example'
  # admin_constraint = lambda { |request| request.env["rack.session"]["user_id"] && User.find(request.env["rack.session"]["user_id"]).admin? }
  # constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  # end

  # Sessions
  post '/session' => 'session#create', as: :session
  delete '/session' => 'session#destroy'

  # Drafts
  post '/drafts/join' => 'drafts#join', as: :join_draft

  resources :users
  resources :drafts
end
