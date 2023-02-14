Dato::Engine.routes.draw do
  get "live", to: "live#show"
  post "publish", to: "publish#create"
end
