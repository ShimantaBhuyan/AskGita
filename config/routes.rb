Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  get 'askBook', to: 'ask_book#index'
  post '/ask', to: 'ask_book#ask'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
