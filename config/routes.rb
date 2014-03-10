require 'sidekiq/web'

Draftin::Application.routes.draw do
  root 'default#index'

  # The API. Only JSON is allowed here.
  namespace :api, :constraints => {:format => 'json'} do
    namespace :v1 do
      post '/drafts/:id/card_sets/:set_id' => 'drafts#add_set'
      delete '/drafts/:id/card_sets/:set_id' => 'drafts#remove_set'
      get '/drafts/:id/start' => 'drafts#start'
      get '/drafts/:id/status' => 'drafts#status'
      get '/drafts/:id/select_card' => 'drafts#select_card'
      get '/drafts/:id/next_pack' => 'drafts#next_pack'
      resources :drafts
    end
  end

  get '/example' => 'default#example'
  # admin_constraint = lambda { |request| request.env["rack.session"]["user_id"] && User.find(request.env["rack.session"]["user_id"]).admin? }
  # constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
  # end

  # Sessions
  post '/session' => 'session#create', as: :session
  delete '/session' => 'session#destroy'

  # Drafts
  post '/drafts/join' => 'drafts#add_user', as: :join_draft
  delete '/drafts/:id/leave' => 'drafts#remove_user'

  resources :users
  resources :drafts
end
