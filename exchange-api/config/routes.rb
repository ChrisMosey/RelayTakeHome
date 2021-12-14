Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :exchange

  get "/all_rates", to: "exchange#all_rates"
  get "/get_exchange_rate", to: "exchange#get_exchange_rate"
end
