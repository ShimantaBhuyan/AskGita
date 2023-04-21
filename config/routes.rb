Rails.application.routes.draw do
  post '/ask', to: 'ask_book#ask'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "ask_book#index"
end
