Lolwut::Application.routes.draw do
  resources :users

  get '/control', :to => 'browser#index'
end
