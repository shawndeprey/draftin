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
      get '/drafts/:id/end_draft' => 'drafts#end_draft'
      resources :drafts
      resources :comments
    end
  end

  # Pages
  get '/about' => 'default#about', as: :about
  get '/support_development' => 'default#donate', as: :donate

  # Sessions
  post '/session' => 'session#create', as: :session
  delete '/session' => 'session#destroy'

  # Drafts
  post '/drafts/join' => 'drafts#add_user', as: :join_draft
  delete '/drafts/:id/leave' => 'drafts#remove_user'

  # Users
  get '/users/:id/my_cards' => 'users#export_cards'
  get '/users/:id/my_cards_list' => 'users#export_cards_list'
  get '/users/reset_password_request' => 'users#reset_password_request'
  get '/users/reset_password' => 'users#reset_password'
  get '/users/:id/verify' => 'users#verify'

  # Admin
  admin_constraint = lambda { |request| request.env["rack.session"]["user_id"] && User.find(request.env["rack.session"]["user_id"]).admin }
  constraints admin_constraint do
    mount Sidekiq::Web => '/admin/sidekiq'
    get '/admin' => 'default#admin'
  end
  get '/example' => 'default#example'

  resources :users
  resources :drafts
  resources :feedbacks
  resources :articles
end
