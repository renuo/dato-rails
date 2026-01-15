Rails.application.routes.draw do
  root to: "home#show"
  get "/home", to: "home#show"
end
