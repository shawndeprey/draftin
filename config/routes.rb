Draftin::Application.routes.draw do
  root 'default#index'
  get '/example' => 'default#example'
end
